DBNAME=realtytrac
OWNER=arthur
FORECLOSURE_DATA_DICT=/home/arthur/Downloads/RealtyTrac/datadict_foreclosure.csv

# Create the database
. create_db.sh $DBNAME $OWNER

# Create the foreclosure table
python create_from_data_dict.py "foreclosure" $FORECLOSURE_DATA_DICT "property_id" | sudo -u postgres psql -d $DBNAME -f -
