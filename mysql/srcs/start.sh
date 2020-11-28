#!/bin/sh
rc-status
rc-update add mariadb
/etc/init.d/mariadb restart
rc-service telegraf start
tail -f /dev/null