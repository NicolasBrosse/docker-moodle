FROM php:7.4-fpm

ENV PHP_INI_DIR /usr/local/etc/php
COPY ./php.ini "$PHP_INI_DIR/php.ini"

RUN apt-get -y update && apt-get install -y \
    g++ \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    libpng-dev \
    zlib1g-dev

RUN docker-php-ext-install mysqli 
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install gd

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install soap

# Redis
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Memcached
RUN apt-get install -y libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

WORKDIR /var/www/html/
RUN mkdir /var/moodledata

COPY ./moodle_data /var/moodledata
RUN chown -R www-data:www-data /var/moodledata

COPY ./src /var/www/html
COPY ./config.php /var/www/html/config.php
RUN chown -R www-data:www-data /var/www/html/*

RUN echo "*/15 * * * * /usr/bin/php /var/www/html/admin/cli/cron.php >/dev/null" >> /etc/crontab
RUN touch /var/log/cron.log