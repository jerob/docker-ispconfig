#!/bin/bash
if [ $SQL_BACKUP = 1 ]
then
MUSER=root
MPASS=pass
BACKUP=/var/backup/sql
NOW="$(date +"%d-%m-%Y_%H%M")"
OLD="$(date +"%d-%m-%Y" -d '-7 day')"
# create directory
mkdir -p "$BACKUP/sql/$NOW/"
# all databases
mysqldump -u $MUSER --password=$MPASS --all-databases --single-transaction > "$BACKUP/sql/$NOW/all_databases.sql"
# backup each base of the database
DBS="$(mysql -u $MUSER -p$MPASS -Bse 'show databases')"
for db in $DBS
do
	mysqldump -u $MUSER --password=$MPASS $db --single-transaction > "$BACKUP/sql/$NOW/$db.sql"
done
# delete old sql
rm -r $BACKUP/sql/$OLD*
fi
