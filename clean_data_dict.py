'''
Script to pre-process the data dictionary provided by RealtyTrac.

First, remove the extraneous spaces with sed
sed "s/  //g" ~/Downloads/temp.csv > ~/Downloads/temp1.csv
'''

import csv
import re

regex = re.compile('^\d+$')
results = []

# Read in only those rows that have an field ID (the others are formatting errors)
with open('/home/arthur/Downloads/RealtyTrac/DFS_3.0_Catalog_of_Elements_v1.7.csv', 'r') as stream:
    reader = csv.reader(stream)
    for l, row in enumerate(reader):
        if l == 0:
            header = row
            continue

        if regex.match(row[0]) is not None:
            results.append(row)

# Write out only those rows with a field ID
with open('/home/arthur/Downloads/RealtyTrac/DFS_3.0_Catalog_of_Elements_v1.7_clean.csv', 'w') as stream:
    writer = csv.writer(stream)
    writer.writerow(header)
    for row in results:
        writer.writerow(row)
