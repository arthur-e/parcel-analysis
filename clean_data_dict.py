'''
Script to pre-process the data dictionary provided by RealtyTrac.

First, remove the extraneous spaces with sed
sed "s/  //g" ~/Downloads/temp.csv > ~/Downloads/temp1.csv
'''

import csv
import re
import sys

if __name__ == '__main__':
    regex = re.compile('^\d+$')
    results = []

    inp = '/home/arthur/Downloads/RealtyTrac/DFS_3.0_Catalog_of_Elements_v1.7.csv'
    if len(sys.argv) > 1:
        inp = sys.argv[1]

    out = '/home/arthur/Downloads/RealtyTrac/DFS_3.0_Catalog_of_Elements_v1.7_clean.csv'
    if len(sys.argv) > 2:
        out = sys.argv[2]

    # Read in only those rows that have an field ID (the others are formatting errors)
    with open(inp, 'r') as stream:
        reader = csv.reader(stream)
        for l, row in enumerate(reader):
            if l == 0:
                header = row
                continue

            if regex.match(row[0]) is not None:
                results.append(row)

    # Write out only those rows with a field ID
    with open(out, 'w') as stream:
        writer = csv.writer(stream)
        writer.writerow(header)
        for row in results:
            writer.writerow(row)
