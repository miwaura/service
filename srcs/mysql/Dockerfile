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
RUN /etc/init.d/mariadb restart && mysql -e "CREATE DATABASE dbtest;" &&\
mysql -e "create user 'dbuser'@'%' identified by 'password'"&&\
mysql -e "grant all on dbtest.* to 'dbuser'@'%';"&&\
mysql -e "FLUSH PRIVILEGES;"
COPY /srcs/start.sh /tmp/start.sh
RUN sed -i 's/skip-networking/skip-networking\=0/g' /etc/my.cnf.d/mariadb-server.cnf
RUN chmod +x /tmp/start.sh
CMD ["/tmp/start.sh"]
