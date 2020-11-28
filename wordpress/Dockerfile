FROM alpine:3.12
# 参考サイト　https://wiki.alpinelinux.org/wiki/WordPress

RUN apk update && apk add vim openrc nginx
RUN mkdir /run/openrc
RUN touch /run/openrc/softlevel
COPY /srcs/start.sh /tmp/start.sh
COPY ./srcs/default.conf /etc/nginx/conf.d/default.conf
# wordpress
RUN mkdir -p /usr/share/webapps/
RUN cd /usr/share/webapps/ && wget http://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress
# # mysql-clientがないと動かせない
RUN apk update && apk add mysql-client

RUN chown -R nginx /usr/share/webapps/
COPY ./srcs/wp-config.php /usr/share/webapps/wordpress/wp-config.php

RUN apk add php7-fpm php7-mcrypt php7-soap \
php7-openssl php7-gmp php7-pdo_odbc php7-json \
php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 \
php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype php7-session php7-mbstring
RUN export PHP_FPM_USER="www" \
&& export PHP_FPM_GROUP="www" \
&& export PHP_FPM_LISTEN_MODE="0660" \
&& export PHP_MEMORY_LIMIT="512M" \
&& export PHP_MAX_UPLOAD="50M" \
&& export PHP_MAX_FILE_UPLOAD="200" \
&& export PHP_MAX_POST="100M" \
&& export PHP_DISPLAY_ERRORS="On" \
&& export PHP_DISPLAY_STARTUP_ERRORS="On" \
&& export PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR" \
&& export PHP_CGI_FIX_PATHINFO=0
RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf \
&& sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf \
&& sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf \
&& sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf \
&& sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf #uncommenting line 
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini \
&& sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini \
&& sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini \
&& sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini \
&& sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini \
&& sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
RUN adduser -D -g 'www' www
COPY ./srcs/www.conf /etc/php7/php-fpm.d/www.conf
RUN mv var/lib/nginx/html/index.html /usr/share/webapps/
# phpmyadmin
RUN cd /usr/share/webapps \
&& wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz\
&& tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz && rm phpMyAdmin-5.0.2-all-languages.tar.gz\
&& mv phpMyAdmin-5.0.2-all-languages phpmyadmin
RUN chmod -R 777 /usr/share/webapps/
RUN ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin
COPY ./srcs/config.inc.php /usr/share/webapps/phpmyadmin/config.inc.php
# 変更点
RUN sed -i -e 's/memory_limit =/memory_limit = -1/g' etc/php7/php.ini
# phpmyadmin user data がないと動かない

# telegraf
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk add telegraf@testing
RUN sed -i -e 's/hostname = ""/hostname = "wp"/g' /etc/telegraf.conf
# composeの時はコンテナ名、くーばーの時は別
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/in:8086"\]/g' /etc/telegraf.conf

RUN chmod 777 /tmp/start.sh
CMD ["/tmp/start.sh"]

# chmod -R 777 /usr/share/webapps/
# / # ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin
# / # apk add  php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom







# apk add php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7
# -imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7
# -ldap php7-ctype php7-dom
# apk add php php-fpm
# rc-service php-fpm startできなかった

# vi /etc/nginx/conf.d/default.conf




# RUN wp cli update && wp core download --allow-root
# wp core install --title=test --admin_user=test --admin_password=test --admin_email=test@test.com --url=$http://127.0.0.1:8000/wordpress/ --path=/usr/share/webapps/wordpress/
# wp user create ywake ywake@test.com  --display_name="ywake" --role=editor --user_pass="ywake" --allow-root --path=/usr/share/webapps/wordpress/
# mysql -h mysql-container  -u dbuser -D dbtest -p
# 他のコンテナからアクセス

# RUN export PHP_FPM_USER="www" \
# && export PHP_FPM_GROUP="www" \
# && export PHP_FPM_LISTEN_MODE="0660" \
# && export PHP_MEMORY_LIMIT="512M" \
# && export PHP_MAX_UPLOAD="50M" \
# && export PHP_MAX_FILE_UPLOAD="200" \
# && export PHP_MAX_POST="100M" \
# && export PHP_DISPLAY_ERRORS="On" \
# && export PHP_DISPLAY_STARTUP_ERRORS="On" \
# && export PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR" \
# && export PHP_CGI_FIX_PATHINFO=0
# sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf #uncommenting line 
# sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini && sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini && sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
# adduser -D -g 'www' www
# rc-service php-fpm7 restart
# /etc/php7/php-fpm.d www.conf
# user = www
# group = www
# etc/nginx/conf.d/default.conf 
# fast_cgi ->127.0.0.1:9000
# 本来　unix:/run/php/php7.3-fpm.sock