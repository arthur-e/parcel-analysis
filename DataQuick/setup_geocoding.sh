DBNAME=los_angeles
OWNER=arthur
DQ_DATA_DIR=/home/arthur/Downloads/DataQuick_LosAngeles
GIS_DIR=/home/arthur/Workspace/Dissertation/GIS_data/shp
GEOCODE_DATA_DICT=$DQ_DATA_DIR/geocode_layout_munged.csv

# Create the record (Recorder) table
sudo -u postgres psql -d $DBNAME -c "DROP TABLE geocoding_index;"
python create_from_data_dict.py "geocoding_index" $GEOCODE_DATA_DICT "sa_property_id" | sudo -u postgres psql -d $DBNAME -f -

read -n 1 -p "Inflate DataQuick data and insert into database? [Y/n] " cont
echo ""
if [ "$cont" = "Y" ]; then
    # echo "Inflating data..."
    # unzip $DQ_DATA_DIR/Geocode_Index.ZIP -d $DQ_DATA_DIR

    echo "Converting from fixed width to CSV..."
    # Also filters to Los Angeles bounding box
    # General form of spatial filter... ($2 > X_MIN && $2 < X_MAX && $3 > Y_MIN && $3 < Y_MAX)
    # ...Where negative coords are first converted to positive values (because of DataQuick's stupid index)
    sh convert_fixed_width_to_csv.sh $GEOCODE_DATA_DICT 6 "," $DQ_DATA_DIR/GEO_INDEX_1.TXT | gawk -F "\"*,\"*" '{ if ($2 > 114 && $2 < 119.6 && $3 > 33.3 && $3 < 35.9) print }' - > $DQ_DATA_DIR/GEO_INDEX_1_filtered.csv

    echo "Inserting data into database table(s)..."
    sudo -u postgres psql -d $DBNAME -c "COPY geocoding_index FROM '${DQ_DATA_DIR}/GEO_INDEX_1_filtered.csv' WITH DELIMITER ',' NULL AS ''"

    echo "Indexing table(s)..."
    sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_geocoding_index_sa_property_id ON geocoding_index USING btree (sa_property_id);"
fi
