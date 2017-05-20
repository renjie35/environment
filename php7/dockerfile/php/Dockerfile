#php
FROM php:7.1.4-fpm-alpine
RUN docker-php-ext-install pdo_mysql
RUN pecl install redis-3.1.2 
RUN pecl install xdebug-2.5.3 
RUN docker-php-ext-enable redis xdebug 

#install composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
