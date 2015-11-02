DBNAME=realtytrac
OWNER=arthur
FORECLOSURE_DATA_DICT=/home/arthur/Downloads/RealtyTrac/datadict_foreclosure.csv
RECORDER_DATA_DICT=/home/arthur/Downloads/RealtyTrac/REALTYTRAC_DLP_3.0_Recorder_Layout.csv

# Create the database
. create_db.sh $DBNAME $OWNER

# Create the record (Recorder) table
python create_from_data_dict.py "record" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the foreclosure table
python create_from_data_dict.py "foreclosure" $FORECLOSURE_DATA_DICT "property_id" | sudo -u postgres psql -d $DBNAME -f -
