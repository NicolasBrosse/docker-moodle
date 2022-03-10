#!/bin/bash

# DB Container Backup Script Template
# ---
# This backup script can be used to automatically backup databases in docker containers.
# It currently supports mariadb, mysql and bitwardenrs containers.
# 


DAYS=1
BACKUPDIR=./backups
BACKUPDIRV=./backups/volumes
BACKUPDIRSQL=./backups/sql
LOGS=../backups/logs/logs.out
TIMESTAMP=$(date)

#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3
#exec 1>$LOGS/log.backup 2>&1
# Everything below will go to the file 'log.out':

# backup all mysql/mariadb containers

CONTAINER=$(docker ps --format '{{.Names}}:{{.Image}}' | grep 'mysql\|mariadb' | cut -d":" -f1)

echo $CONTAINER

if [ ! -d $BACKUPDIR ]; then
    mkdir -p $BACKUPDIRSQL
    mkdir -p $BACKUPDIRV
fi

for i in $CONTAINER; do
    MYSQL_DATABASE=$(docker exec $i env | grep MYSQL_DATABASE |cut -d"=" -f2)
    MYSQL_PWD=$(docker exec $i env | grep MYSQL_ROOT_PASSWORD |cut -d"=" -f2)

    docker exec -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_PWD=$MYSQL_PWD \
        $i mysqldump -u root --skip-comments $MYSQL_DATABASE \
         | gzip > $BACKUPDIRSQL/$i-$MYSQL_DATABASE-$(date +"%Y%m%d%H%M").sql.gz >$LOGS

    OLD_BACKUPS=$(ls -1 $BACKUPDIRSQL/$i*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
    find $BACKUPDIR -name "$i*.gz" -daystart -mtime +$DAYS -delete >$LOGS 
    fi >$LOGS 
    tar -czf $BACKUPDIRV/moodle_data-$(date +"%Y%m%d%H%M").tar.gz ./app/moodle_data

    OLD_BACKUPS=$(ls -1 $BACKUPDIRV/*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
    find $BACKUPDIR -name "*.gz" -daystart -mtime +$DAYS -delete >$LOGS
    fi
    
done

echo "$TIMESTAMP Backup for Databases completed"