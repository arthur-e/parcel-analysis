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

if __name__ == '__main__':
    script = ['CREATE TABLE %s (' % sys.argv[1]]
    padding = 30
    traversed_fields = []

    with open(sys.argv[2], 'r') as data_dict:
        reader = csv.reader(data_dict)
        for l, row in enumerate(reader):
            if l == 0:
                continue

            # Some field records are duplicated by SQL Server; skip these
            if row[1].lower() in traversed_fields:
                continue

            # If the Precision field is empty, this is a "FILLER" field
            if row[4].strip() == '':
                continue

            # Concatenate the "Field Information" and "ANSI Data Type" and "Precision"
            if row[2].strip() in ('character', 'character varying'):
                script.append('  %s%s(%d),' % (row[1].lower().ljust(padding),
                    row[2].strip(), int(row[4])))

            elif row[2].strip().lower() == 'no equivalent':
                # TODO Create a field data type whitelist and map non-standard types
                # Use the "SQL Server Data Type" instead
                if row[3].strip() == 'tinyint':
                    script.append('  %s%s,' % (row[1].lower().ljust(padding),
                        'smallint'))

                else:
                    script.append('  %s%s,' % (row[1].lower().ljust(padding),
                        row[3].strip()))

            else:
                script.append('  %s%s,' % (row[1].lower().ljust(padding),
                    row[2].strip()))

            traversed_fields.append(row[1].lower())

    if len(sys.argv) > 3:
        script.append('  PRIMARY KEY(%s)' % sys.argv[3])

    script.append(');\n')
    sys.stdout.write('\n'.join(script))
