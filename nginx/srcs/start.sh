#!/bin/sh
rc-status
rc-service nginx start
rc-update add vsftpd default
rc-service vsftpd restart
rc-service php-fpm7 start
tail -f /dev/null