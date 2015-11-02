'''
Writes out a list of the field widths from an input data dictionary or layout
file; for converting from fixed width to a CSV.
'''

import csv
import sys

if __name__ == '__main__':
    widths = []
    i = int(sys.argv[2]) # The index of the field "length" column

    with open(sys.argv[1], 'r') as stream:
        reader = csv.reader(stream)
        for l, row in enumerate(reader):
            if l == 0:
                continue

            # Skip empty lines
            if row[0].strip() == '':
                continue

            widths.append(row[i])

    sys.stdout.write('%s\n' % ' '.join(widths))
