BACKUPDIRV=../backups/volumes
BACKUPDIRapp=../backups/volumes/app
BACKUPDIRSQL=../backups/sql
LOGS=./backups/logs



echo -e "\033[35mRESTAURATION Database\033[0m"

echo -e "\033[36mvoule-vous unzip un fichier .gz?\033[0m"

select yn in "Yes" "No" ; do
    case $yn in
        Yes ) echo -e "\033[36mETAPE 1 unzip le fichier .gz:\033[0m"
        for filepath in $BACKUPDIRSQL/*gz
        do
            echo $(basename $filepath)
        done
        echo -e "\033[36mindiquez la date du fichier à unzip '(/Y/m/d/H/M)' :\033[0m"
        read -p date: datevar
        gunzip $BACKUPDIRSQL/docker-moodle-db-1-moodle-$datevar.sql.gz
        break ;;
        No ) break ;;
    esac
done

echo -e "\033[36mvoule-vous restaurer la database via le fichier .sql?\033[0m"

select yn in "Yes" "No" ; do
    case $yn in
        Yes ) echo -e "\033[36mETAPE 2 restaurer la database via le fichier .sql\033[0m"
        for filepath in $BACKUPDIRSQL/*sql
        do
            echo $(basename $filepath)
        done
        echo -e "\033[36mindiquez la date de la database à restaurer '(/Y/m/d/H/M)' :\033[0m"
        read -p date: datevar
        docker exec -e MYSQL_DATABASE=moodle -e MYSQL_PWD=root docker-moodle-db-1 bash -c 'mysql -u root moodle < /opt/backups/docker-moodle-db-1-moodle-'$datevar'.sql'
        break ;;
        No ) break ;;
    esac
done

echo -e "\033[35mRESTAURATION volume moodle_data\033[0m"

echo -e "\033[36mvoule-vous untar le fichier tar.gz?\033[0m"

select yn in "Yes" "No" ; do
    case $yn in
        Yes ) echo -e "\033[36mETAPE 1 untar le fichier tar.gz:\033[0m"
        for filepath in $BACKUPDIRV/*
        do
            echo $(basename $filepath)
        done
        echo -e "\033[36mindiquez la date de la date du fichier à untar '(/Y/m/d/H/M)' :\033[0m"
        read -p date: datevar
        $PWD
        tar -xzf $BACKUPDIRV/moodle_data-$datevar.tar.gz -C $BACKUPDIRV
        break ;;
        No ) break ;;
    esac
done 

echo -e "\033[36mvoule-vous restaurer moodle_data?\033[0m"

select yn in "Yes" "No" ; do
    case $yn in
        Yes ) 
            if  [[ -d "./app/moodle_data" ]]; then 
                echo -e "\033[31merror moodle_data existe déjà\033[0m"
                exit 0
            else 
                sudo mv  $BACKUPDIRapp/moodle_data app;
                sudo rm -rf $BACKUPDIRapp; break ;
            fi
            ;;
        No ) break ;;
    esac
done 