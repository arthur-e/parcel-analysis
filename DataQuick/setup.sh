DBNAME=los_angeles
OWNER=arthur
DQ_DATA_DIR=/home/arthur/Downloads/DataQuick_LosAngeles
GIS_DIR=/home/arthur/Workspace/Dissertation/GIS_data/shp
ASSESSOR_DATA_DICT=$DQ_DATA_DIR/20121127_UNIVMI_ASSESSOR_LAYOUT.csv
RECORDER_DATA_DICT=$DQ_DATA_DIR/20121127_UNIVMI_HISTORY_LAYOUT.csv

# Create the database
. create_db.sh $DBNAME $OWNER

# Create the record (Recorder) table
python create_from_data_dict.py "transactions" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the assessment (Assessor Record) table
python create_from_data_dict.py "assessments" $ASSESSOR_DATA_DICT "sa_property_id" | sudo -u postgres psql -d $DBNAME -f -

# Insert 2000 Census geometries: Downloaded from <https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html>
# unzip ~/Downloads/tr06_d00_shp.zip -d ~/Downloads
# ogr2ogr -f "ESRI Shapefile" -where "COUNTY IN ('037', '059', '065', '071', '111')" -s_srs "EPSG:4269" -t_srs "EPSG:26911" $GIS_DIR/LosAngeles/census_tracts_2000_utm11n.shp ~/Downloads/tr06_d00_shp/tr06_d00.shp
# rm -fr ~/Downloads/tr06_d00_shp
shp2pgsql -s 26911 -I $GIS_DIR/LosAngeles/census_tracts_2000_utm11n.shp public.census2000_tracts | sudo -u postgres psql -h localhost -d $DBNAME
sudo -u postgres psql -h localhost -d $DBNAME -c "VACUUM ANALYZE census2000_tracts (geom);"

# Insert 2010 Census geometries: Downloaded from <https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html>
# unzip ~/Downloads/gz_2010_06_140_00_500k.zip -d ~/Downloads
# ogr2ogr -f "ESRI Shapefile" -where "COUNTY IN ('037', '059', '065', '071', '111')" -s_srs "EPSG:4269" -t_srs "EPSG:26911" $GIS_DIR/LosAngeles/census_tracts_2010_utm11n.shp ~/Downloads/gz_2010_06_140_00_500k/gz_2010_06_140_00_500k.shp
# rm -fr ~/Downloads/gz_2010_06_140_00_500k
shp2pgsql -s 26911 -I $GIS_DIR/LosAngeles/census_tracts_2010_utm11n.shp public.census2010_tracts | sudo -u postgres psql -h localhost -d $DBNAME
sudo -u postgres psql -h localhost -d $DBNAME -c "VACUUM ANALYZE census2010_tracts (geom);"

read -n 1 -p "Inflate RealtyTrac data and insert into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
    echo "Inflating data..."
    # unzip $DQ_DATA_DIR/20121127_UNIVMI_ASSESSOR.ZIP -d $DQ_DATA_DIR
    for file in $(ls $DQ_DATA_DIR/*UNIVMI_HISTORY*.ZIP)
    do
        unzip $file -d $DQ_DATA_DIR
    done

    echo "Converting from fixed width to CSV..."
    mkdir $DQ_DATA_DIR/csv
    sh convert_fixed_width_to_csv.sh $ASSESSOR_DATA_DICT 6 "|" $DQ_DATA_DIR/UNIVMI_ASSESSOR.TXT > $DQ_DATA_DIR/csv/Assessor_data_LA.csv

    for file in $(ls $DQ_DATA_DIR/*UNIVMI_HISTORY*.TXT)
    do
        filename=`expr match $file '.*/\(.*\).TXT'`
        echo "Converting ${file}.TXT..."
        sh convert_fixed_width_to_csv.sh $RECORDER_DATA_DICT 6 "|" $file > "$DQ_DATA_DIR/csv/${filename}.csv"
    done

    echo "Inserting data into database tables..."
    # sudo -u postgres psql -d $DBNAME -c "COPY assessments FROM '$DQ_DATA_DIR/csv/Assessor_data_LA.csv' WITH DELIMITER '|' NULL AS ''"

    for file in $(ls $DQ_DATA_DIR/csv/*UNIVMI_HISTORY*.csv)
    do
        sudo -u postgres psql -d $DBNAME -c "COPY transactions FROM '${file}' WITH DELIMITER '|' NULL AS ''"
    done

    # echo "Vacuuming tables..."
    sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE transactions;"
    sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE assessments;"
fi
