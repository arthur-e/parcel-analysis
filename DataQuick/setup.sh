DBNAME=los_angeles
OWNER=arthur
DQ_DATA_DIR=/home/arthur/Downloads/DataQuick_LosAngeles
BASE_DIR=/usr/local/dev/parcel-analysis # The location of the repository
GIS_DIR=/home/arthur/Workspace/Speed-of-Change/GIS_data/shp
ASSESSOR_DATA_DICT=$DQ_DATA_DIR/20121127_UNIVMI_ASSESSOR_LAYOUT.csv
RECORDER_DATA_DICT=$DQ_DATA_DIR/20121127_UNIVMI_HISTORY_LAYOUT.csv

# Create the database
# . create_db.sh $DBNAME $OWNER

read -n 1 -p "Insert CPI tables into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  sudo -u postgres psql -h localhost -d $DBNAME -f $BASE_DIR/sql/create_CPI_inflation_adjustment_table.sql
fi

read -n 1 -p "Insert Shapefiles into spatial database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  # Insert 2010 Census geometries: Downloaded from <https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html>
  shp2pgsql -s 26911 -I $GIS_DIR/LA_County_census_tracts_2010_utm11n.shp public.census2010_tracts | sudo -u postgres psql -h localhost -d $DBNAME
  sudo -u postgres psql -h localhost -d $DBNAME -c "VACUUM ANALYZE census2010_tracts (geom);"
  # Add FIPS codes for this table
  sudo -u postgres psql -h localhost -d $DBNAME -c "ALTER TABLE census2010_tracts ADD COLUMN fips varchar(13);"
  sudo -u postgres psql -h localhost -d $DBNAME -c "UPDATE census2010_tracts SET fips = state || county || tract;"

  # Insert 2000 Census geometries: Downloaded from <https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html>
  shp2pgsql -s 26911 -I $GIS_DIR/LA_County_census_tracts_2000_utm11n.shp public.census2000_tracts | sudo -u postgres psql -h localhost -d $DBNAME
  sudo -u postgres psql -h localhost -d $DBNAME -c "VACUUM ANALYZE census2000_tracts (geom);"
  # Add FIPS codes for this table
  sudo -u postgres psql -h localhost -d $DBNAME -c "ALTER TABLE census2000_tracts ADD COLUMN fips varchar(13);"
  sudo -u postgres psql -h localhost -d $DBNAME -c "UPDATE census2000_tracts SET fips = state || county || tract;"

  # Insert 1990 Census geometries
  shp2pgsql -s 26911 -I $GIS_DIR/LA_County_census_tracts_1990_utm11n.shp public.census1990_tracts | sudo -u postgres psql -h localhost -d $DBNAME
  sudo -u postgres psql -h localhost -d $DBNAME -c "VACUUM ANALYZE census1990_tracts (geom);"
  # Add FIPS codes for this table
  sudo -u postgres psql -h localhost -d $DBNAME -c "ALTER TABLE census1990_tracts ADD COLUMN fips varchar(13);"
  sudo -u postgres psql -h localhost -d $DBNAME -c "UPDATE census1990_tracts SET fips = st || co || tract_name;"

  # NOTE: As an example... Insert 2010 Census geometries: Downloaded from <https://www.census.gov/geo/maps-data/data/cbf/cbf_tracts.html>
  # unzip ~/Downloads/gz_2010_06_140_00_500k.zip -d ~/Downloads
  # ogr2ogr -f "ESRI Shapefile" -where "COUNTY IN ('037', '059', '065', '071', '111')" -s_srs "EPSG:4269" -t_srs "EPSG:26911" $GIS_DIR/LosAngeles/census_tracts_2010_utm11n.shp ~/Downloads/gz_2010_06_140_00_500k/gz_2010_06_140_00_500k.shp
  # rm -fr ~/Downloads/gz_2010_06_140_00_500k
  # NOTE: Manually selected LA County ('037') only, and removed outlying islands
fi

read -n 1 -p "Inflate DataQuick data and insert into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then

  echo "Creating tables..."
  # Create the record (Recorder) table
  python create_from_data_dict.py "transactions" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

  # Create the assessment (Assessor Record) table
  python create_from_data_dict.py "assessments" $ASSESSOR_DATA_DICT "sa_property_id" | sudo -u postgres psql -d $DBNAME -f -

  echo "Inflating data..."
  unzip $DQ_DATA_DIR/20121127_UNIVMI_ASSESSOR.ZIP -d $DQ_DATA_DIR
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
  sudo -u postgres psql -d $DBNAME -c "COPY assessments FROM '$DQ_DATA_DIR/csv/Assessor_data_LA.csv' WITH DELIMITER '|' NULL AS ''"

  for file in $(ls $DQ_DATA_DIR/csv/*UNIVMI_HISTORY*.csv)
  do
      sudo -u postgres psql -d $DBNAME -c "COPY transactions FROM '${file}' WITH DELIMITER '|' NULL AS ''"
  done
fi
