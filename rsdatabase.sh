BACKUPDIRV=./backups/volumes
BACKUPDIRapp=./backups/volumes/app
BACKUPDIRSQL=./backups/sql


echo RESTAURATION Database

echo "voule-vous unzip un fichier .gz?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo ETAPE 1 unzip le fichier .gz:
        for filepath in $BACKUPDIRV/*
        do
            echo $(basename $filepath)
        done
        echo indiquez la date du fichier à unzip '(/Y/m/d/H/M)' :
        read -p date: datevar
        echo gunzip  $BACKUPDIRSQL/docker-moodle-db-1-moodle-$datevar.sql.gz
        break ;;
        No ) break ;;
    esac
done

echo "voule-vous restaurer la database via le fichier .sql?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo ETAPE 2 restaurer la database via le fichier .sql
        for filepath in $BACKUPDIRV/*
        do
            echo $(basename $filepath)
        done
        echo indiquez la date de la database à restaurer '(/Y/m/d/H/M)' :
        read -p date: datevar
        echo docker exec -e MYSQL_DATABASE=moodle -e MYSQL_PWD=root docker-moodle-db-1 bash -c 'mysql -u root moodle < /opt/backups/docker-moodle-db-1-moodle-'$datevar'.sql'
        break ;;
        No ) break ;;
    esac
done 

echo RESTAURATION volume moodle_data

echo "voule-vous untar le fichier tar.gz?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo ETAPE 1 untar le fichier tar.gz:
        for filepath in $BACKUPDIRV/*
        do
            echo $(basename $filepath)
        done
        echo indiquez la date de la date du fichier à untar '(/Y/m/d/H/M)' :
        read -p date: datevar
        echo $PWD
        tar -xzf  $BACKUPDIRV/moodle_data-$datevar.tar.gz -C $BACKUPDIRV
        break ;;
        No ) break ;;
    esac
done 

echo ETAPE 2 restauration de moodle_data

echo "voule-vous restaurer moodle_data?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
            if  [[ -d "./app/moodle_data" ]]; then 
                echo error 
                exit 0
            else 
                mv  $BACKUPDIRapp/moodle_data app;
                rm -rf $BACKUPDIRapp; break ;
            fi
            ;;
        No ) break ;;
    esac
done 