#!/bin/sh
rc-status
rc-service nginx start
rc-update add vsftpd default
rc-service vsftpd restart
rc-service php-fpm7 start
rc-service telegraf start
tail -f /dev/null