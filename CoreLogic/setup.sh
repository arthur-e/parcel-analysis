DBNAME=corelogic
OWNER=arthur
DQ_DATA_DIR=/home/arthur/Downloads/CoreLogic
DQ_DATA_ARCHIVE=$DQ_DATA_DIR/CoreLogic_Detroit_metro_data.zip
BASE_DIR=/usr/local/dev/parcel-analysis # The location of the repository
#GIS_DIR=/home/arthur/Workspace/Speed-of-Change/GIS_data/shp
ASSESSOR_DATA_DICT=$DQ_DATA_DIR/layouts/Tax_Layout_w_Property_Level_lat_long_w_code_01262017.csv
RECORDER_DATA_DICT=$DQ_DATA_DIR/layouts/Deed_Layout_PropertyLevel_Lat_Long_11172016.csv
SCHEMA="detroit."

# Create the database
# . create_db.sh $DBNAME $OWNER

# Create the record (Recorder) table
# python create_from_data_dict.py "${SCHEMA}transactions" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the assessment (Assessor Record) table
python create_from_data_dict.py "${SCHEMA}assessments" $ASSESSOR_DATA_DICT "map_reference_1" 35 | sudo -u postgres psql -d $DBNAME -f -

# read -n 1 -p "Insert CPI tables? [Y/n] " cont
# echo ""
# if [ "$cont" = "Y" ]; then
#     sudo -u postgres psql -h localhost -d $DBNAME -f $BASE_DIR/sql/create_CPI_inflation_adjustment_table.sql
# fi

# read -n 1 -p "Insert CoreLogic data into database? [Y/n] " cont
# echo ""
# if [ "$cont" = "Y" ]; then
    # echo "Inflating data..."
    # unzip $DQ_DATA_ARCHIVE -d $DQ_DATA_DIR

    echo "Inserting data into database tables..."
    for file in $(ls $DQ_DATA_DIR/TaxAssessor*Detroit*.txt)
    do
        # Remove leading whitespace with sed; remove null bytes with sed
        # See also: https://stackoverflow.com/questions/1347646/postgres-error-on-insert-error-invalid-byte-sequence-for-encoding-utf8-0x0
        sed 's/^[ \t]*//' $file | sed 's/\x00//g' > $DQ_DATA_DIR/temp.txt
        sudo -u postgres psql -d $DBNAME -c "COPY "${SCHEMA}assessments" FROM '${DQ_DATA_DIR}/temp.txt' WITH DELIMITER '|' NULL AS ''"
        rm $DQ_DATA_DIR/temp.txt
    done

    # for file in $(ls $DQ_DATA_DIR/Transactions*Detroit*.txt)
    # do
    #     sudo -u postgres psql -d $DBNAME -c "COPY "${SCHEMA}transactions" FROM '${file}' WITH DELIMITER '|' NULL AS ''"
    # done
# fi
