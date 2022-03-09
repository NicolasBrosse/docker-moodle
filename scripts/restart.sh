
sudo docker compose down 
echo "voule-vous supprimer les volumes?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo docker volume rm docker-moodle_content docker-moodle_db_data docker-moodle_redis_data; break;;
        No ) break ;;
    esac
done
echo "voule-vous lançer un docker-compose build?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo docker compose build; break;;
        No ) break ;;
    esac
done
sudo docker compose up -d