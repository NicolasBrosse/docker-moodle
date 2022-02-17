docker compose down 
#docker volume rm docker-moodle_content docker-moodle_db_data docker-moodle_redis_data
docker compose build
docker compose up -d