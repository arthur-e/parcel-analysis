# Working with CoreLogic Data

Because the Tax Assessor, Deed sales, and Foreclosure data are each presented in a single large text file, it can be difficult to work with just the state(s), count(ies), or citi(es) that you're interested in.
Even very large text files can be manipulated easily as text streams on a Unix-like operating system, hwoever.

We can use command-line programs like `awk` and `sed` to extract certain lines from the massive, combined Tax Assessor, Deed, and Foreclosure record files.

**Don't unzip that file!**
Our Mac OSX or GNU/Linux system also comes with a handy tool for streaming that text straight out of the ZIP file (without decompressing it)!

## Tax Assessor Data

Because some of the rows in the Tax Assessor data **have no SITUS State code (e.g., "MI")**, if you want to make sure you're not missing any parcels whatsoever, you should filter on FIPS codes instead of on the SITUS State codes.

### Filtering and Extracting Data Subsets

#### By County

The Tax Assessor data have a handy FIPS code field for counties.
A private company, Scientific Telephone Samples, maintains [a list of all U.S. counties and their FIPS codes](http://www.stssamples.com/county-fips.asp); you can consult this list to find the FIPS code(s) for the count(ies) you're interested in.
[There's also a list available from the Bureau of Economic Analysis](https://www.bea.gov/regional/docs/msalist.cfm) (FIPS codes are in the third column of this spreadsheet).
Then, you can filter the FIPS code field (1st column of the text file) for entries that match these code(s) you're intersted in.

```sh
# Example: For Los Angeles or Orange counties
unzip -c Michigan_Uni_Tax_AKZA_85HRQ5.zip | awk -F "|" '{ if ($1 == 06037 || $1 == 06059) print }' > filtered_sample.txt
```

#### By Bounding Box

If you have a study area in mind that isn't encompassed by municipal, county, or state boundaries (e.g., parcels within a certain distance of X), you can do a bounding-box search just as easily.
A bounding box is a rectangular area defined by the bottom-left and upper-right coordinates, e.g., two latitude-longitude pairs.
You can get a bounding box [easily in QGIS](http://www.qgis.org/en/site/) by clicking on the button to the right of the "Coordinates" box in the bottom toolbar.
See the image below for an example.

![](image_QGIS_extent.png)

A bounding box query looks similar to our previous `awk` queries.
In this example, the bounding box from QGIS shows `-83.84,42.00 : -82.53,42.92`, which means that our `awk` query should be:

```sh
# Extract those records located in the Detroit metro area:
unzip -c Michigan_Uni_Tax_AKZA_85HRQ5.zip | awk -F "|" '{ if ($31 >= 42 && $31 <= 42.92 && $32 >= -83.84 && $32 <= -82.53) print }' > filtered_sample.txt
```

## Deed Sales

The deed sales data can be filtered the same way as the Tax Assessor data.
Column 1 is the county-level FIPS code.

### Notes on Fields

The following is a description of the apparent usefulness of a few fields, based on my assessment of their coverage for the Detroit metropolitan area (which may not be representative of other study areas):

Field Name                   | Useful? | Notes
-----------------------------|---------|----------------------------------------------------------------
`corporate_indicator`        |   Maybe | Has a "Y" (Yes?) for 1.4 million records but the rest are blank
`absentee_owner_status`      |      No | Blank for all records in Detroit metro area
`sale_code`                  |      No | Blank for all except 47 records in Detroit metro area
`document_type`              |     Yes | Rich number of codes that are populated
`transaction_type`           |     Yes | Rich number of codes that are populated
`mortgage_loan_type_code`    |     Yes | Rich number of codes that are populated
`mortgage_deed_type`         |     Yes | Rich number of codes that are populated
`land_use`                   |   Maybe | Rich number of codes are populated; 100,000+ are blank
`property_indicator`         |   Mabye | Rich number of codes, but 227,000+ rows are blank
`inter_family`               |     Yes | True or False for all records; totals are credible
`resale_or_new_construction` |     Yes | "M" or "N" for almost all records
`foreclosure`                |   Maybe | 565,445 records are "Y" and the rest are blank
`cash_or_mortgage_purchase`  |   Maybe | "Q" or "R" for many records but over 2 million are blank
`equity_flag`                |   Maybe | "Y" for a few records but the vast majority are blank
`refi_flag`                  |      No | "Y" for only a few records and the rest are blank
`residential_model_indicator`|   Maybe | "Y" for most records but the rest are blank

Note that while ~565,000 Deed records are marked "Y" (Yes) in the `foreclosure` field, there are over 784,000 Foreclosure records in the Detroit metro area.

## Foreclosures

The foreclosure data are formatted a little differently; the county-level FIPS code is in column 2 (`$2` in `awk`), therefore any `awk` query should look like:

```sh
# Example: For Los Angeles or Orange counties
unzip -c Michigan_Uni_FCL_AKZA_85HRYY.zip | awk -F "|" '{ if ($2 == 06037 || $2 == 06059) print }' > filtered_sample.txt
```

# Using a Relational Database

Okay, so you've got the data filtered to your area of interest.
You may now want to store it in a relational (SQL) database.
This requires you to create the table and all of its columns in advance and to know what data type each column will store.
This information is contained in one of the layout files:

- Tax Assessor layout file: `Tax_Layout_w_Property_Level_lat_long_w_code_01262017.xlsx`
- Deed layout file: `Deed_Layout_PropertyLevel_Lat_Long_11172016.xlsx`

The layout files are not perfect.
**Because the individual Tax Assessor, Deed, and Foreclosure records have human data-entry errors, there may be a value in a particular field in your data that does not correspond to the data type specified in the layout file.**
You may find you need to change the data type for a field from a numeric (integer, floating point) type to a character string type because some odd alphabetical characters found their way into a given field.
Here's an example error message from PostgreSQL, which is trying to store a "number" in a field that has an integer type.

```
ERROR:  invalid input syntax for integer: "9 6051140"
CONTEXT:  COPY transactions, line 4910, column mailing_property_address_zip_code: "9 6051140"
```

The error message is explaining that the column `mailing_property_address_zip_code` doesn't look like an integer.
We can see a valid ZIP code (6051140) here, but there is an odd 9 and a space before it.
It's not reasonable to try and change the data, so let's change our database to accomodate this oddity.
Simply re-create the table, making `mailing_property_address_zip_code` a character (e.g., `varchar`) field instead of an integer field.

Field length is another issue that crops up.
The layout file has a number of recommended field widths for the database but the data often exceed them.
For instance, `owner_1_last_name` in the Tax Assessor data has a field width of only 30 characters but some of the values in this field are more than 30 characters long.
When in doubt, just change the length to 255 (the maximum for most "character varying" fields) or to a text field (unlimited width) type.

**You don't want to just make all your fields text fields, though.**
Having constraints on the data type and length can help you fix some really hard problems, for example, when one of the text columns in your data contains a delimiter character (e.g., contains a "|" for pipe-delimited data).
This is extremely hard to detect and fix; the error that results is a general one--basically, there appear to be more columns in the data than your table has defined.
If you remove one pipe/ column from the end of the problematic line, you might get a more familiar error message related to trying to stuff the wrong value into the wrong column; and this error will crop up right next to the column that contains the delimiter character!
So, that's just one example why having constraints on column types can be helpful.
