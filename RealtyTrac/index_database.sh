#!/usr/bin/bash
# Creates an index on appropriate columns

DBNAME=realtytrac

# Indexes columns of transactions table
# Indexes `sr_property_id`
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_property_id ON transactions USING hash (sr_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_date_transfer ON transactions USING btree (sr_date_transfer);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_date_filing ON transactions USING btree (sr_date_filing);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE transactions;" # Update statistics

# Indexes columns of foreclosures table
# Indexes `sa_property_id` for faster lookups on Assessor property ID
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosures_sa_property_id ON foreclosures USING hash (sa_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosures_recording_date ON foreclosures USING btree (recording_date);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_foreclosures_sa_scm_id ON foreclosures USING btree (sa_scm_id);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE foreclosures;" # Update statistics

# Indexes columns of assessments table
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_assr_year ON assessments USING btree (assr_year);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_sa_appraise_yr ON assessments USING btree (sa_appraise_yr);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_taxyear ON assessments USING btree (taxyear);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_sa_parcel_nbr_change_yr ON assessments USING btree (sa_parcel_nbr_change_yr);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_sa_scm_id ON assessments USING btree (sa_scm_id);"
sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE assessments;" # Update statistics
