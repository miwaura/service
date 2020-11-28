FROM alpine:latest

RUN apk update && apk add openrc nginx openssl vim 
RUN mkdir /run/openrc
RUN touch /run/openrc/softlevel
# COPY /srcs/index.html /www/
COPY /srcs/start.sh /tmp/start.sh
# ftp test
RUN apk add lftp vsftpd
COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN adduser -D ftp_user \
&& echo "ftp_user:ftp_pass" | chpasswd
COPY ./srcs/.lftprc .
RUN mv .lftprc ~
# ftp test
RUN mkdir /etc/nginx/ssl \
	&& openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
	&& openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/C=JP/ST=Tokyo/L=/O=/OU=/CN=localhost/DNS=localhost" \
	&& openssl x509 -days 3650 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt
# php
RUN apk add php7-fpm
COPY ./srcs/default.conf /etc/nginx/conf.d/default.conf
RUN mkdir var/lib/nginx/html/test
COPY ./srcs/index.php /var/lib/nginx/html/test/index.php

# 試したこと
RUN apk add php7-fpm php7-mcrypt php7-soap \
php7-openssl php7-gmp php7-pdo_odbc php7-json \
php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 \
php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype php7-session php7-mbstring
RUN sed -i'.bak' 's/^#rc_sys=""/rc_sys="lxc"/' /etc/rc.conf \
&& sed -i 's/^#rc_provide="!net"/rc_provide="loopback net"/' /etc/rc.conf \
&& sed -i'.bak' '/getty/d' /etc/inittab \
&& sed -i'.bak' 's/mount -t tmpfs/# mount -t tmpfs/' /lib/rc/sh/init.sh \
&& sed -i'.bak' 's/hostname $opts/# hostname $opts/' /etc/init.d/hostname \
&& sed -i'.bak' 's/cgroup_add_service$/# cgroup_add_service/' /lib/rc/sh/openrc-run.sh
COPY ./srcs/www.conf /etc/php7/php-fpm.d/www.conf

# telegraf
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk add telegraf@testing
RUN sed -i -e 's/hostname = ""/hostname = "nginx-test"/g' /etc/telegraf.conf
# composeの時はコンテナ名、くーばーの時は別
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/in:8086"\]/g' /etc/telegraf.conf


RUN chmod 777 /tmp/start.sh
CMD ["/tmp/start.sh"]




# # docker run -d -it -p 8080:80 -p 443:443 --name
# # docker exec -it