#php
FROM php:7.1.4-fpm-alpine
RUN apk update \
    && apk add --no-cache \
        $PHPIZE_DEPS openssl-dev pcre-dev supervisor dcron \
    && pecl channel-update pecl.php.net \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo_mysql \
    && apk del $PHPIZE_DEPS \
    && apk del openssl-dev \
    && apk del pcre-dev \
    && rm -rf /tmp/pear/temp/* \
    && rm -rf /tmp/pear/cache/* \
    && rm -rf /tmp/pear/download/*

#install composer
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
