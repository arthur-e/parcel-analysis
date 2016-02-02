#!/usr/bin/bash
# Creates an index on appropriate columns

DBNAME=realtytrac

# Indexes columns of record table
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_record_sr_property_id ON record USING hash (sr_property_id);"

# Indexes columsn of foreclosure table
# Indexes `sa_property_id` for faster lookups on Assessor property ID
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosure_sa_property_id ON foreclosure USING hash (sa_property_id);"
