Notes
=====

GNU Awk (overrides `awk` but is also called `gawk`) is required for this but it may not be installed already.
On Debian systems (including the Ubuntu distributions) it is likely not available; try:

```sh
sudo apt-get install gawk
```

**You can quickly get up-and-running with the script `setup.sh` after setting the variables defined within.**

Issues with RealtyTrac Metadata
===============================

In the metadata/ layout files provided there were some elements that simply weren't true (or couldn't be true):

* In the Assessor layout file, after converting it to a CSV, I changed the "Empty Value" field for the `process_id` field from "No" to "Yes" because, in fact, there are NULL values in the `process_id` field within the Assessor data.
* The `sr_unique_id` field is **not** unique in the Assessor data and therefore cannot be used as a primary key.
* In the Foreclosure layout file, after converting it to a CSV, I changed the "Empty Value" field for multiple fields from "No" to "Yes" because, in fact, there are NULL values in the `trustee_unit_nbr` and `fd_beneficiary_unit_nbr` and `parcel_nbr_raw` fields.

Workflow
========

To import some foreclosure data into a database, we want to perform the following steps, in order:

1. Save the data dictionary/ layout file as a CSV and edit as necessary. **You must make sure that the header is in the first row and there are no extra rows (every row is a field description).**
2. **If necessary,** clean the RealtyTrac data dictionary (`clean_data_dict.py`).
3. Create the database to hold our foreclosure records.
4. Convert the fixed-width files to comma-separated variable (CSV) files to be read.
5. Copy data to the table.

Create the Database and Schema
------------------------------

Create a database `realtytrac` owned by `arthur`:

```sh
$ . create_db.sh realtytrac arthur
```

Then, create the `record` (Recorder) table, where `sr_unique_id` is the primary key.

```sh
$ python create_from_data_dict.py "record" data_dict.csv "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -
```

Convert Fixed-Width Files to CSV
--------------------------------

The length column is always the fourth column, so leave the index at "4" as in the following example.
Where the field length column is at index 4 and we want to use the ">" character as a delimiter:

```sh
$ . convert_fixed_width_to_csv.sh data_dict.csv 4 ">" fixed_width_data.txt > output.csv
```

Because the fixed-width data contain so many different characters, I found it necessary to use the following delimiters with each data file:

* Recorder data: The right angle-bracket ">" character
* Assessor data: The vertical bar "|" character
* Foreclosure data: The vertical bar "|" character

Copy Data to Database Table
---------------------------

For example, copying data to the `record` (Recorder) table:

```sh
DBNAME=realtytrac
TABLE_NAME=record
sudo -u postgres psql -d $DBNAME -c "COPY $TABLE_NAME FROM 'test.csv' WITH DELIMITER '>' NULL AS ''"
```
