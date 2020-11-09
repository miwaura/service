#!/bin/sh
rc-status
rc-update add mariadb
/etc/init.d/mariadb restart
tail -f /dev/null