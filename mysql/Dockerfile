FROM alpine:3.12
# 参考サイト　https://wiki.alpinelinux.org/wiki/WordPress

RUN apk update && apk add vim openrc lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel

COPY ./srcs/lighttpd.conf /etc/lighttpd/lighttpd.conf
# mysql
RUN apk update && apk add mysql mysql-client
RUN /etc/init.d/mariadb setup
RUN rc-status
# shellscriptで書く、ボリュームを使うため
RUN /etc/init.d/mariadb restart && mysql -e "CREATE DATABASE dbtest;" &&\
mysql -e "create user 'dbuser'@'%' identified by 'password'"&&\
mysql -e "grant all on dbtest.* to 'dbuser'@'%';"&&\
mysql -e "FLUSH PRIVILEGES;"
COPY /srcs/start.sh /tmp/start.sh
RUN sed -i 's/skip-networking/skip-networking\=0/g' /etc/my.cnf.d/mariadb-server.cnf
# telegraf
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk add telegraf@testing
RUN sed -i -e 's/hostname = ""/hostname = "mysql-con"/g' /etc/telegraf.conf
# composeの時はコンテナ名、くーばーの時は別
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/in:8086"\]/g' /etc/telegraf.conf

RUN chmod +x /tmp/start.sh
CMD ["/tmp/start.sh"]
