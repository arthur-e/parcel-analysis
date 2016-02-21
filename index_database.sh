#!/usr/bin/bash
# Creates an index on appropriate columns

DBNAME=realtytrac

# Indexes columns of transaction table
# Indexes `sr_property_id`
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transaction_sr_property_id ON transaction USING hash (sr_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transaction_sr_date_transfer ON transaction USING btree (sr_date_transfer);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transaction_sr_date_filing ON transaction USING btree (sr_date_filing);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE transaction;" # Update statistics

# Indexes columns of foreclosure table
# Indexes `sa_property_id` for faster lookups on Assessor property ID
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosure_sa_property_id ON foreclosure USING hash (sa_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosure_recording_date ON foreclosure USING btree (recording_date);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE foreclosure;" # Update statistics

# Indexes columns of assessment table
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessment_assr_year ON assessment USING btree (assr_year);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessment_sa_appraise_yr ON assessment USING btree (sa_appraise_yr);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessment_taxyear ON assessment USING btree (taxyear);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessment_sa_parcel_nbr_change_yr ON assessment USING btree (sa_parcel_nbr_change_yr);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE foreclosure;" # Update statistics
