DBNAME=realtytrac
OWNER=arthur
RT_DATA_DIR=/home/arthur/Downloads/RealtyTrac
ASSESSOR_DATA_DICT=$RT_DATA_DIR/REALTYTRAC_DLP_3.0_Assessor_NO_Geo_Layout.csv
FORECLOSURE_DATA_DICT=$RT_DATA_DIR/REALTYTRAC_DLP_3.0_Foreclosure_Layout.csv
RECORDER_DATA_DICT=$RT_DATA_DIR/REALTYTRAC_DLP_3.0_Recorder_Layout.csv

# Create the database
. create_db.sh $DBNAME $OWNER

# Create the record (Recorder) table
python create_from_data_dict.py "transactions" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the assessment (Assessor Record) table
python create_from_data_dict.py "assessments" $ASSESSOR_DATA_DICT "sa_property_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the foreclosure table
python create_from_data_dict.py "foreclosures" $FORECLOSURE_DATA_DICT "unique_id_notice" | sudo -u postgres psql -d $DBNAME -f -

# Insert Census geometries
GIS=/home/arthur/Workspace/MCubed2015/GIS/shp
shp2pgsql -s 32617 -I $GIS/census_block_groups_2000_utm17n.shp public.census2000_block_groups | sudo -u postgres psql -h localhost -d realtytrac
sudo -u postgres psql -h localhost -d realtytrac -c "VACUUM ANALYZE census2000_block_groups (geom);"

shp2pgsql -s 32617 -I $GIS/census_block_groups_2010_utm17n.shp public.census2010_block_groups | sudo -u postgres psql -h localhost -d realtytrac
sudo -u postgres psql -h localhost -d realtytrac -c "VACUUM ANALYZE census2010_block_groups (geom);"

read -n 1 -p "Inflate RealtyTrac data and insert into database? [Y/n]" cont
echo ""
if [ "$cont" = "Y" ]; then
    echo "Inflating data..."

    # Inflate Recorder data
    unzip $RT_DATA_DIR/University_of_Michigan_Recorder_001.zip -d $RT_DATA_DIR
    unzip $RT_DATA_DIR/University_of_Michigan_Recorder_002.zip -d $RT_DATA_DIR
    unzip $RT_DATA_DIR/University_of_Michigan_Recorder_003.zip -d $RT_DATA_DIR

    # Inflate TaxAssessor data
    unzip $RT_DATA_DIR/University_of_Michigan_TaxAssessor_001.zip -d $RT_DATA_DIR
    unzip $RT_DATA_DIR/University_of_Michigan_TaxAssessor_002.zip -d $RT_DATA_DIR

    # Inflate foreclosure data
    unzip $RT_DATA_DIR/University_of_Michigan_Foreclosure_001.zip -d $RT_DATA_DIR

    echo "Converting from fixed width to CSV..."
    mkdir $RT_DATA_DIR/csv
    for FILE in $(ls $RT_DATA_DIR/University_of_Michigan_Recorder_00*.txt)
    do
        IFS='/' read -a ARR <<< "$FILE"
        TMP="${ARR[(-1)]}"
        FNAME=(${TMP//.txt/ })
        sh convert_fixed_width_to_csv.sh $RECORDER_DATA_DICT 4 ">" $FILE > $RT_DATA_DIR/csv/${FNAME}.csv
    done
    for FILE in $(ls $RT_DATA_DIR/University_of_Michigan_TaxAssessor_00*.txt)
    do
        IFS='/' read -a ARR <<< "$FILE"
        TMP="${ARR[(-1)]}"
        FNAME=(${TMP//.txt/ })
        sh convert_fixed_width_to_csv.sh $ASSESSOR_DATA_DICT 4 "|" $FILE > $RT_DATA_DIR/csv/${FNAME}.csv
    done
    sh convert_fixed_width_to_csv.sh $FORECLOSURE_DATA_DICT 4 "|" $RT_DATA_DIR/University_of_Michigan_Foreclosure_001.txt > $RT_DATA_DIR/csv/University_of_Michigan_Foreclosure_001.csv

    echo "Inserting data into database tables..."
    DBNAME=realtytrac
    for FILE in $(ls $RT_DATA_DIR/csv/*Recorder*.csv)
    do
        sudo -u postgres psql -d $DBNAME -c "COPY transactions FROM '$FILE' WITH DELIMITER '>' NULL AS ''"
    done
    for FILE in $(ls $RT_DATA_DIR/csv/*TaxAssessor*.csv)
    do
        sudo -u postgres psql -d $DBNAME -c "COPY assessments FROM '$FILE' WITH DELIMITER '|' NULL AS ''"
    done
    sudo -u postgres psql -d $DBNAME -c "COPY foreclosures FROM '$RT_DATA_DIR/csv/University_of_Michigan_Foreclosure_001.csv' WITH DELIMITER '' NULL AS ''"

    echo "Vacuuming tables..."
    sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE transactions;"
    sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE assessments;"
    sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE foreclosures;"
fi
