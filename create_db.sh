#!/usr/bin/bash
# Called: $ . create_db.sh dbname owner

POSTGIS_TEMPLATE="postgis-2.2.1"

sudo su -c "createdb $1 --owner $2 --template $POSTGIS_TEMPLATE" - postgres
