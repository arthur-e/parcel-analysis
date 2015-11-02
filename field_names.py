'''
Writes out a list of the field names from an input data dictionary or layout
file; for inserting fields with COPY.
'''

import csv
import sys

if __name__ == '__main__':
    names = []

    with open(sys.argv[1], 'r') as stream:
        reader = csv.reader(stream)
        for l, row in enumerate(reader):
            if l == 0:
                continue

            if row[0].strip() == '':
                continue

            names.append(row[1].lower())

    sys.stdout.write('%s\n' % ', '.join(names))
