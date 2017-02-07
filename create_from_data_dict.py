'''
Generates a CREATE TABLE statement based on a data dictionary, e.g.:

CREATE TABLE distributors (
    did     integer,
    name    varchar(40),
    PRIMARY KEY(did)
);

Called as:
$ python create_from_data_dict.py tablename data_dict.csv primary_key_fieldname
'''

import csv
import sys

PRECISION_FIELD_IDX = 4 # Column index of the precision field

def main(path, pk_field):
    with open(path, 'r') as data_dict:
        reader = csv.reader(data_dict)
        for l, row in enumerate(reader):
            nullable = 'NOT NULL'

            if l == 0:
                header = row
                continue

            # Skip empty or "total" rows
            if row[0].strip() == '':
                continue

            # Some field records are duplicated by SQL Server; skip these
            if row[1].lower() in traversed_fields:
                continue

            # If the Precision field is empty, this is a "FILLER" field
            if row[PRECISION_FIELD_IDX].strip() == '':
                continue

            # Null values allowed?
            if row[header.index('Empty Values')] == 'Yes':
                nullable = 'NULL'

            # The "filler" field is always allowed to be null
            if row[1].lower() == 'filler':
                nullable = 'NULL'

            # Concatenate the "Field Information" and "ANSI Data Type" and "Precision"
            if row[2].strip() in ('character', 'character varying'):
                inp = '  %s%s(%d) %s,' % (row[1].lower().ljust(padding),
                    row[2].strip(), int(row[4]), nullable)

            # Fields for a dollar amount ("AMT") or a principal are specified as integer type but should not be
            elif row[1].find('_AMT') > 0 or row[1].find('AMOUNT') > 0 or row[1].find('_PRINCIPAL') > 0:
                inp = '  %s%s %s,' % (row[1].lower().ljust(padding), 'numeric',
                    nullable)

            # No ANSI equivalent for this SQL Server data type
            elif row[2].strip().lower() == 'no equivalent':
                # TODO Create a field data type whitelist and map non-standard types
                # Use the "SQL Server Data Type" instead
                if row[3].strip() == 'tinyint':
                    inp = '  %s%s %s,' % (row[1].lower().ljust(padding),
                        'smallint', nullable)

                else:
                    inp = '  %s%s %s,' % (row[1].lower().ljust(padding),
                        row[3].strip(), nullable)

            else:
                inp = '  %s%s %s,' % (row[1].lower().ljust(padding),
                    row[2].strip(), nullable)

            # Add the field descriptor string to our script
            script.append(inp)
            traversed_fields.append(row[1].lower())

    if len(sys.argv) > 3:
        script.append('  PRIMARY KEY(%s)' % pk_field)

    else:
        # Remove any trailing comma from the last field descriptor
        script[-1] = script[-1].replace(',', '', 1)

    return script


if __name__ == '__main__':
    script = ['CREATE TABLE %s (' % sys.argv[1]]
    padding = 30
    traversed_fields = []

    # Unpack arguments
    script = main(*sys.argv[2:4])
    script.append(');\n')
    sys.stdout.write('\n'.join(script))
