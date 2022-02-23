#!/bin/bash

# DB Container Backup Script Template
# ---
# This backup script can be used to automatically backup databases in docker containers.
# It currently supports mariadb, mysql and bitwardenrs containers.
# 

DAYS=1
BACKUPDIR=./backups
TIMESTAMP=$(date)

# backup all mysql/mariadb containers

CONTAINER=$(docker ps --format '{{.Names}}:{{.Image}}' | grep 'mysql\|mariadb' | cut -d":" -f1)

echo $CONTAINER

if [ ! -d $BACKUPDIR ]; then
    mkdir -p $BACKUPDIR/sql
    mkdir -p $BACKUPDIR/volumes
fi

for i in $CONTAINER; do
    MYSQL_DATABASE=$(docker exec $i env | grep MYSQL_DATABASE |cut -d"=" -f2)
    MYSQL_PWD=$(docker exec $i env | grep MYSQL_ROOT_PASSWORD |cut -d"=" -f2)

    docker exec -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_PWD=$MYSQL_PWD \
        $i mysqldump -u root --skip-comments $MYSQL_DATABASE \
         | gzip > $BACKUPDIR/sql/$i-$MYSQL_DATABASE-$(date +"%Y%m%d%H%M").sql.gz 

    OLD_BACKUPS=$(ls -1 $BACKUPDIR/sql/$i*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
        find $BACKUPDIR -name "$i*.gz" -daystart -mtime +$DAYS -delete #<logs.txt
    fi
    tar -czf $BACKUPDIR/volumes/moodle_data-$(date +"%Y%m%d%H%M").tar.gz ./app/moodle_data

    OLD_BACKUPS=$(ls -1 $BACKUPDIR/volumes/*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
        find $BACKUPDIR -name "*.gz" -daystart -mtime +$DAYS -delete #<logs.txt
    fi
    
done

echo "$TIMESTAMP Backup for Databases completed"