echo indiquer la date de la database à restaurer '(/Y/m/d/H/M)' :
read -p date: datevar
docker exec -e MYSQL_DATABASE=moodle -e MYSQL_PWD=root docker-moodle-db-1 bash -c 'mysql -u root moodle < /opt/backups/docker-moodle-db-1-moodle-'$datevar'.sql'