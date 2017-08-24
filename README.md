Contains scripts for working with fixed-width real estate data, including deed sales, tax assessor's records, and foreclosure records, as commonly purchased from vendors such as Data Quick, RealtyTrac, and Attom Data Solutions.
Specifically includes support for:

- Conversion from fixed width to delimited (e.g., CSV) format;
- Creation of a relational database table (PostgreSQL) from a layout file;
- Inflation adjustment of home sales and other dollar amounts (from CPI-U for housing, 1982-2015);
- SQL scripts for some analysis, geocoding of transactions, assessments, and foreclosures;

Much of the scripts assume a couple of working objectives because they were developed as part of an applied research project.
I have no intention of changing these any time soon but will consider any pull requests that improve/ generalize this work.
If you're working in a different study area, the intent is that this repo is, at the least, a great place to get inspired/ up-to-speed on using these data.
By subfolder:

- `DataQuick/` - Assumes working in Los Angeles MSA
- `RealtyTrac/` - Assumes working in Detroit-Flint-Ann Arbor CSA

**Disclaimer: No actual real estate data are included in this repository as this would violate data license agreements.**

Dependencies
============

GNU Awk (overrides `awk` but is also called `gawk`) is required for this but it may not be installed already.
On Debian systems (including the Ubuntu distributions) it is likely not available; try:

```sh
sudo apt-get install gawk
```

`dos2unix` may also be required if you are using a non-Windows computer. I discovered Windows-style line endings in the CoreLogic data, for instance.

Data Issues
===========

DataQuick
---------

The layout file for the Tax Assessor data ("Tax_Layout_w_Property_Level_lat_long_w_code_01262017.xlsx") has a few problems:

- It's not clear what the primary key should be. `map_reference_1` is described as "A CoreLogic unique key to link record to the CoreLogic CD Map product" but the field is empty for some rows.
- It specifies a `centroid_code` field that does not exist in the data. This field should NOT be created in the database or all the columns after this column index will be shifted one to the right.
- It does NOT specify the `owner_full_name` field, which is clearly evident in the data. This field should be added to the layout file and a column created in the database.
- The `assessed_year` column is supposed to be a 4-digit year ("YYYY" format or, e.g., "2016"); however, it contains strings like "20160000"--that is, with 4 trailing zeros. This needs to be fixed in the layout file and the database column for `assessed_year` needs to allow 8 digits.
- The columns `front_footage`, `depth_footage`, `living_square_feet`, `ground_floor_square_feet`, `basement_square_feet`, `garage_parking_square_feet`, `total_baths`, and `sale_price` are all described as integer columns in the layout file but they all contain decimal numbers.
- The columns `OWNER_1_LAST_NAME`, `OWNER_1_FIRST_NAME_MI`, `OWNER_2_LAST_NAME`, `OWNER_2_FIRST_NAME_MI`, `SUBDIVISION_NAME` may be too short. At least the first one, which has a specified width of 30 characters, exceeded that limit on Line 16. I defined all these columns to have 255-byte lengths (the maximum for `varchar` type).
- Columns `mail_unit_number` and `zoning` also have incorrect widths. I upgraded these to 255 characters after running into too many edge cases (e.g., "313MAILBOX").

(By the way, most of these issues were discovered on Line 1 of the file! They are not rare!)

RealtyTrac
----------

In the metadata/ layout files provided there were some elements that simply weren't true (or couldn't be true):

* In the Assessor layout file, after converting it to a CSV, I changed the "Empty Value" field for the `process_id` field from "No" to "Yes" because, in fact, there are NULL values in the `process_id` field within the Assessor data.
* The `sr_unique_id` field is **not** unique in the Assessor data and therefore cannot be used as a primary key.
* In the Foreclosure layout file, after converting it to a CSV, I changed the "Empty Value" field for multiple fields from "No" to "Yes" because, in fact, there are NULL values in the `trustee_unit_nbr` and `fd_beneficiary_unit_nbr` and `parcel_nbr_raw` fields.

**Primary Keys:** It's not clear what RealtyTrac intended, but here are some possible primary keys (unique for every record):

    Assessor data:
        sa_property_id ("Unique primary key identifier assigned to a property")

    Foreclosure data:
        unique_id_notice ("Unique transactional identifier for a recorded pre-Forecelosure Notice.")

    Recorder data:
        sr_property_id ("Joined to Assessor data to merge Assessor and Recorder data. Internal identification number assigned to every property") -- NOT UNIQUE
        sr_unique_id ("Unique  ID assigned to the original loan transaction for an Assignment record.")

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

Then, create the `transactions` (Recorder) table, where `sr_unique_id` is the primary key.

```sh
$ python create_from_data_dict.py "transactions" data_dict.csv "sr_unique_id" | sudo -u postgres psql -d $DBNAME -f -
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

For example, copying data to the `transactions` (Recorder) table:

```sh
DBNAME=detroit
TABLE_NAME=transactions
sudo -u postgres psql -d $DBNAME -c "COPY $TABLE_NAME FROM 'test.csv' WITH DELIMITER '>' NULL AS ''"
```

Notes on Datasets
=================

Useful Fields
-------------

- In the Assessor file, the `use_code_std` field is populated for most of the records and describes the type of property. Those codes beginning with an "R" are residential properties; "RSFR" properties are single-family home properties.

Here's an example of field coverage for select fields from the Detroit Metropolitan Statistical Area:

| Dataset  | Field Name          | Coverage
|----------|---------------------|-----------------
| Recorder | sr_deed_type        |  96.5%
| Recorder | sr_doc_type         |  96.0%
| Recorder | sr_tran_type        | 100.0%
| Recorder | sr_arms_length_flag |  21.1%
| Recorder | sr_quitclaim        | 100.0%

Assessor's Tables
-----------------

* `sa_parcel_nbr_change_yr` ("Indicates the year in which the most recent parcel conversion took place."); this ranges wildly from 2001 to 2015 with over 1.2 million properties assigned a year of 0. Some years, like 2004, have 6 properties while others, like 2008, have over 490,000.
* `sa_yr_blt` ("Year in which the primary structure was built on the property")
* `sa_yr_blt_effect` ("Year in which 'permitted' major improvements were made to the property")
* `sa_condition_code` ("Code indicating the state/condition of a particular property"); unfortunately, it is blank for every record.
* `sa_architecture_code` ("Indicates the architectural style of the structure."); it is blank (equal to "0") for almost 98% of the records.
* `sa_construction_code` ("Indicates the material used in the construction of the framework for the structure on the  property."); blank for about 96% of the records.
* `sa_patio_porch_code` ("Indicates the presence or type of patio or porch."); non-null for every record, but there is no code for "not present" so it's unclear what to make of this.
* `sa_pool_code` ("Indicates if there is a pool on the property and/or pool construction material."); blank for about 98% of the records, **which should indicate the property does not have a pool.**
