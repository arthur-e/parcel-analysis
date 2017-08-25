#!/bin/bash

# Filters the raw data (zipped) for relevant records.

ASSESSOR_MASTER_FILE=/home/arthur/Desktop/Michigan_Uni_Tax_AKZA_85HRQ5.zip
TRANSACTIONS_MASTER_FILE=/home/arthur/Desktop/Michigan_Uni_Deed_KZA_85HRZB.zip
DQ_DATA_DIR=/home/arthur/Downloads/CoreLogic

# Extract Los Angeles, Detroit parcel records
unzip -c $ASSESSOR_MASTER_FILE | awk -F "|" '{ if ($1 == 06037 || $1 == 06059) print }' > $DQ_DATA_DIR/TaxAssessor_filtered_LosAngeles.txt
unzip -c $ASSESSOR_MASTER_FILE | awk -F "|" '{ if ($1 == 26099 || $1 == 26125 || $1 == 26163) print }' > $DQ_DATA_DIR/TaxAssessor_filtered_Detroit.txt

# Extract Los Angeles, Detroit transactions records
unzip -c $TRANSACTIONS_MASTER_FILE | awk -F "|" '{ if (($1 == "" && $29 == "MI") || ($1 == 26163 || $1 == 26125 || $1 == 26099)) print }' > $DQ_DATA_DIR/Transactions_filtered_Detroit.txt
unzip -c $TRANSACTIONS_MASTER_FILE | awk -F "|" '{ if (($1 == "" && $29 == "CA") || ($1 == 06037 || $1 == 06059)) print }' > $DQ_DATA_DIR/Transactions_filtered_LosAngeles.txt
