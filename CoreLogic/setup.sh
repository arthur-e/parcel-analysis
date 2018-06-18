#!/bin/bash

# Creates and populates the PostgreSQL database. Prior to running:
#   1. Files "Transactions.txt", "TaxAssessor.txt" are on the Desktop
# NOTE: If you need to *append* data to an existing table, you will need to
#   remove the primary key constraint and field, e.g.:
#   ALTER TABLE detroit.transactions DROP CONSTRAINT transactions_pkid;
#   ALTER TABLE detroit.transactions DROP COLUMN pkid;

DBNAME=corelogic
OWNER=arthur
SOURCE_DIR=/usr/local/dev/parcel-analysis/
DQ_DATA_DIR=/home/arthur/Desktop
GIS_DATA_DIR=~/Workspace/Dissertation/GIS_data/
BASE_DIR=/usr/local/dev/parcel-analysis # The location of the repository
ASSESSOR_DATA_DICT=~/Workspace/Dissertation/Parcel_Data/CoreLogic/Tax_Layout_w_Property_Level_lat_long_w_code_01262017.csv
RECORDER_DATA_DICT=~/Workspace/Dissertation/Parcel_Data/CoreLogic/Deed_Layout_PropertyLevel_Lat_Long_11172016.csv
FORECLOSURE_DATA_DICT=~/Workspace/Dissertation/Parcel_Data/CoreLogic/FCL_Layout_Bulk_w_Code_Tables_04072017.csv
SCHEMA="detroit."
SRID=32617 # UTM 17N Detroit; 26911 is UTM 11N Los Angeles

# Create the database
# . create_db.sh $DBNAME $OWNER

read -n 1 -p "Insert Shapefile geometries? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  shp2pgsql -s $SRID -g geom -D -I $GIS_DATA_DIR/shp/Detroit/grid_DetroitMetro_2000m_study_areas.shp "${SCHEMA}grid_2000m" | psql -d corelogic -h localhost
fi

read -n 1 -p "Insert CPI tables? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  psql -h localhost -d $DBNAME -f $BASE_DIR/sql/create_CPI_inflation_adjustment_table.sql
fi

read -n 1 -p "Insert Tax Assessor data into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  # Create the assessment (Assessor Record) table
  psql -d $DBNAME -c "DROP TABLE ${SCHEMA}assessments;"
  python $SOURCE_DIR/create_from_data_dict.py "${SCHEMA}assessments" $ASSESSOR_DATA_DICT | psql -d $DBNAME -f -

  for file in $(ls $DQ_DATA_DIR/*TaxAssessor*.txt)
  do
    # Remove leading whitespace with sed; remove null bytes with sed; remove backslash characters with tr
    # See also: https://stackoverflow.com/questions/1347646/postgres-error-on-insert-error-invalid-byte-sequence-for-encoding-utf8-0x0
    echo "Cleaning raw text input..."
    sed 's/^[ \t]*//' $file | sed 's/\x00//g' | tr '\\' ' ' > $DQ_DATA_DIR/temp1.txt
    dos2unix -n $DQ_DATA_DIR/temp1.txt $DQ_DATA_DIR/temp2.txt

    echo "Inserting Tax Assessor data into database tables..."
    psql -d $DBNAME -c "COPY "${SCHEMA}assessments" FROM '${DQ_DATA_DIR}/temp2.txt' WITH DELIMITER '|' NULL AS '';"
    rm $DQ_DATA_DIR/temp1.txt $DQ_DATA_DIR/temp2.txt
  done

  echo "Adding primary key..."
  psql -d $DBNAME -c "ALTER TABLE ${SCHEMA}assessments ADD COLUMN pkid bigserial PRIMARY KEY;"
fi

read -n 1 -p "Insert Transactions data into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  # Drop it if it already exists
  read -n 1 -p "Drop any existing Transactions data table? [Y/n] " drop
  echo ""
  if [ "$drop" = "Y" ]; then
    psql -d $DBNAME -c "DROP TABLE ${SCHEMA}transactions;"
  fi

  # Create the record (Recorder) table
  python $SOURCE_DIR/create_from_data_dict.py "${SCHEMA}transactions" $RECORDER_DATA_DICT | psql -d $DBNAME -f -

  for file in $(ls $DQ_DATA_DIR/*Transactions*.txt)
  do
    echo "Cleaning raw text input..."
    sed 's/^[ \t]*//' $file | tr '\\' ' ' > $DQ_DATA_DIR/temp1.txt

    echo "Inserting Transactions data into database tables..."
    psql -d $DBNAME -c "COPY "${SCHEMA}transactions" FROM '${DQ_DATA_DIR}/temp1.txt' WITH DELIMITER '|' NULL AS '';"
    rm $DQ_DATA_DIR/temp1.txt
  done

  echo "Adding primary key..."
  psql -d $DBNAME -c "ALTER TABLE ${SCHEMA}transactions ADD COLUMN pkid bigserial PRIMARY KEY;"
fi

read -n 1 -p "Insert Foreclosures data into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
  # Create the record (Recorder) table
  psql -d $DBNAME -c "DROP TABLE ${SCHEMA}foreclosures;"
  python $SOURCE_DIR/create_from_data_dict.py "${SCHEMA}foreclosures" $FORECLOSURE_DATA_DICT | psql -d $DBNAME -f -

  for file in $(ls $DQ_DATA_DIR/*Foreclosures*.txt)
  do
    echo "Cleaning raw text input..."
    sed 's/^[ \t]*//' $file | tr '\\' ' ' > $DQ_DATA_DIR/temp1.txt

    echo "Inserting Foreclosure data into database tables..."
    psql -d $DBNAME -c "COPY "${SCHEMA}foreclosures" FROM '${DQ_DATA_DIR}/temp1.txt' WITH DELIMITER '|' NULL AS '';"
    rm $DQ_DATA_DIR/temp1.txt
  done

  echo "Adding primary key..."
  psql -d $DBNAME -c "ALTER TABLE ${SCHEMA}foreclosures ADD COLUMN pkid bigserial PRIMARY KEY;"
fi
