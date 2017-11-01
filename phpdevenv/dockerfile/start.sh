supervisord -c /etc/supervisord.conf \
&& crond \
&& nginx \
&& php-fpm \
&& top