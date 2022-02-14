#!/bin/bash

# DB Container Backup Script Template
# ---
# This backup script can be used to automatically backup databases in docker containers.
# It currently supports mariadb, mysql and bitwardenrs containers.
# 

DAYS=1
BACKUPDIR=~/OneDrive/Documents/docker/docker-moodle/backups
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
        $i mysqldump -u root $MYSQL_DATABASE \
         | gzip > $BACKUPDIR/sql/$i-$MYSQL_DATABASE-$(date +"%Y%m%d%H%M").sql.gz

    OLD_BACKUPS=$(ls -1 $BACKUPDIR/$i*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
    find $BACKUPDIR -name "$i*.gz" -daystart -mtime +$DAYS -delete
    fi
    #docker exec  --volumes-from $i -v $BACKUPDIR/volumes:/backup $i bash -c "cd /var/moodledata && tar cvf /backup/moodledata.tar ."
    
done

echo "$TIMESTAMP Backup for Databases completed"