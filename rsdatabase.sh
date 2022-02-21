echo RESTAURATION Database

echo ETAPE 1 unzip le fichier .gz:
ls ./backups/sql/$i*.gz
echo indiquez la date du fichier à unzip '(/Y/m/d/H/M)' :
read -p date: datevar
echo gunzip  backups/sql/docker-moodle-db-1-moodle-$datevar.sql.gz


echo ETAPE 2 restaurer la database via le fichier .sql
ls ./backups/sql/$i*.sql
echo indiquez la date de la database à restaurer '(/Y/m/d/H/M)' :
read -p date: datevar
echo docker exec -e MYSQL_DATABASE=moodle -e MYSQL_PWD=root docker-moodle-db-1 bash -c 'mysql -u root moodle < /opt/backups/docker-moodle-db-1-moodle-'$datevar'.sql'


echo RESTAURATION volume moodle_data

echo ETAPE 1 untar le fichier tar.gz:
ls ./backups/volumes/$i*.gz
echo indiquez la date de la date du fichier à untar '(/Y/m/d/H/M)' :
read -p date: datevar
echo tar -xzvf  backups/volumes/moodle_data$datevar.tar.gz