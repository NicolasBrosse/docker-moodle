## Building

### Running the application
`docker-compose up -d`

### Rebuild an image
```
docker volume rm docker-moodle_content
docker-compose build app --no-cache
```


## Moodle

### Adjusting PHP settings

Change the settings of *moodle/php.ini* and rebuild the app by running `docker-compose build app`

### Moodle caching

In **/cache/admin.php** admin panel, add a new Redis store :

server : `redis:6379`

and a new Memcached store : 

server : `127.0.0.1:11211`
