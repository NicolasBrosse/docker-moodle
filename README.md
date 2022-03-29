## Building

### Setting environment variables

- Copy `.env-sample` to `.env` and set the variables.
- Copy `.env-sample` to `.env.prod` to run in production environment.

### Adding Moodle

Run the `setup.sh` script

or :

- copy moodle source directory into `app/src` so that `app/src/index.php` exists
- create `app/moodle_data` directory


### Running the application

`docker-compose up -d`

### Rebuild an image

```
docker volume rm docker-moodle_content
docker-compose build app --no-cache
```

## Moodle

### Moodle caching

In **/cache/admin.php** admin panel, add a new Redis store :

server : `redis:6379`

and a new Memcached store : 

server : `127.0.0.1:11211`

## Production

```
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

./scripts/setup.sh
./init-letsencrypt.sh

docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
```