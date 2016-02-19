Real-Estate Transactions in Recorder Data
=========================================

The real-estate transactions in the recorder data are various deed transactions, including quitclaims and sales.

Getting Changes in Value by Year
--------------------------------

As an example, let's consider changes in home values by year.
We are interested in the following fields from the data.

* `sr_val_transfer`, which "contains the dollar amount...in an ownership changing transaction."
* `sr_date_transfer`, which "contains the official filing date for the transaction."
* `sr_full_part_code`, which indicates whether the `sr_val_transfer` amount "represents the full sale amount or a partial sale amount."
* `sr_mail_zip`, which contains the ZIP code of the c

The codes for `sr_full_part_code` are as follows:

    C - Documentary transfer tax calculated (for `sr_tax_transfer` only?)
    F - Full consideration
    N - Documentary transfer tax due = 0 (for `sr_tax_transfer` only?)
    U - No `sr_val_transfer` was keyed, because document was recorded as non-disclosed

When `sr_full_part_code` is blank it is "unknown and assumed to be a full consideration transfer."
