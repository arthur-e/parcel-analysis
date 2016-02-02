DBNAME=realtytrac
OWNER=arthur
ASSESSOR_DATA_DICT=/home/arthur/Downloads/RealtyTrac/REALTYTRAC_DLP_3.0_Assessor_NO_Geo_Layout.csv
FORECLOSURE_DATA_DICT=/home/arthur/Downloads/RealtyTrac/REALTYTRAC_DLP_3.0_Foreclosure_Layout.csv
RECORDER_DATA_DICT=/home/arthur/Downloads/RealtyTrac/REALTYTRAC_DLP_3.0_Recorder_Layout.csv

# Create the database
. create_db.sh $DBNAME $OWNER

# Create the record (Recorder) table
python create_from_data_dict.py "record" $RECORDER_DATA_DICT "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the assessment (Assessor Record) table
python create_from_data_dict.py "assessment" $ASSESSOR_DATA_DICT "sa_property_id" | sudo -u postgres psql -d $DBNAME -f -

# Create the foreclosure table
python create_from_data_dict.py "foreclosure" $FORECLOSURE_DATA_DICT "unique_id_notice" | sudo -u postgres psql -d $DBNAME -f -
