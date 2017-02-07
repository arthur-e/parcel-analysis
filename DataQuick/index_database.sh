#!/usr/bin/bash
# Creates an index on appropriate columns

DBNAME=los_angeles

# Indexes columns of transactions table
echo "Indexing transactions table..."
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_property_id ON transactions USING btree (sr_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_date_transfer ON transactions USING btree (sr_date_transfer);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_val_transfer ON transactions USING btree (sr_val_transfer);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_sr_date_filing ON transactions USING btree (sr_date_filing);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_transactions_mm_fips_county_name ON transactions USING btree (mm_fips_county_name);"
# echo "Analyzing transactions table..."
# sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE transactions;" # Update statistics

# Indexes columns of assessments table
echo "Indexing assessments table..."
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_sa_property_id ON assessments USING btree (sa_property_id);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_assr_year ON assessments USING btree (assr_year);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_sa_appraise_yr ON assessments USING btree (sa_appraise_yr);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_taxyear ON assessments USING btree (taxyear);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_use_code_std ON assessments USING btree (use_code_std);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_use_code_muni ON assessments USING btree (use_code_muni);"
sudo -u postgres psql -d $DBNAME -c "CREATE INDEX idx_assessments_mm_fips_county_name ON assessments USING btree (mm_fips_county_name);"
# echo "Analyzing assessments table..."
# sudo -u postgres psql -d $DBNAME -c "VACUUM ANALYZE assessments;" # Update statistics
