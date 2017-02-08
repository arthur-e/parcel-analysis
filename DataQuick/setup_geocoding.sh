DBNAME=los_angeles
OWNER=arthur
DQ_DATA_DIR=/home/arthur/Downloads/DataQuick_LosAngeles
GIS_DIR=/home/arthur/Workspace/Dissertation/GIS_data/shp
GEOCODE_DATA_DICT=$DQ_DATA_DIR/geocode_layout.csv

# Create the record (Recorder) table
python create_from_data_dict.py "geocoding_index" $GEOCODE_DATA_DICT "sa_property_id" 35 | sudo -u postgres psql -d $DBNAME -f -

read -n 1 -p "Inflate DataQuick data and insert into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
    # echo "Inflating data..."
    # unzip $DQ_DATA_DIR/20121127_UNIVMI_ASSESSOR.ZIP -d $DQ_DATA_DIR

    echo "Converting from fixed width to CSV..."
    mkdir $DQ_DATA_DIR/csv
    sh convert_fixed_width_to_csv.sh $GEOCODE_DATA_DICT 6 "," $DQ_DATA_DIR/GEO_INDEX_head.txt > $DQ_DATA_DIR/csv/geocodes_LA.csv

    echo "Inserting data into database tables..."
    sudo -u postgres psql -d $DBNAME -c "COPY geocoding_index FROM '$DQ_DATA_DIR/csv/geocodes_LA.csv' WITH DELIMITER ',' NULL AS ''"
fi
