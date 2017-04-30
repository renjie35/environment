#php
FROM php:7.1-fpm
RUN docker-php-ext-install pdo_mysql 
RUN pecl install redis-3.1.2 
RUN pecl install xdebug-2.5.3 
RUN docker-php-ext-enable redis xdebug 