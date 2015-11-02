'''
Script to subset the data dictionary to a particular record type (e.g., only
the fields associated with foreclosure records. Called, e.g.:

$ python susbset_data_dict.py data_dict.csv Foreclosure output.csv
'''

import csv
import sys

if __name__ == '__main__':
    if len(sys.argv) < 4:
        raise ValueError('Did not provide the required arguments')

results = []
with open(sys.argv[1], 'r') as stream:
    reader = csv.reader(stream)
    for l, row in enumerate(reader):
        if l == 0:
            header = row
            continue

        if row[header.index(sys.argv[2])].strip() == 'Y':
            results.append(row)

with open(sys.argv[3], 'w') as stream:
    writer = csv.writer(stream)
    writer.writerow(header)
    for row in results:
        writer.writerow(row)
        
