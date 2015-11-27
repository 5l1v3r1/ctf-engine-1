#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
PASS2=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
echo -e "admin: $PASS\nctfDbUser: $PASS2" > /root/mysql/pass.txt

# CTF-WEB

mysql -uroot -e "CREATE DATABASE ctf CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql -uroot -e "GRANT ALL PRIVILEGES ON ctf.* To 'ctfDbUser'@'%' IDENTIFIED BY '$PASS2'"

mysql ctf -uroot < /root/mysql/ctf.sql
mysql ctf -uroot < /root/mysql/countries.sql

echo -e "<?php
\n const DB_ENGINE = 'mysql';
\n const DB_HOST = 'localhost';
\n const DB_PORT = 3306;
\n const DB_NAME = 'ctf';
\n const DB_USER = 'ctfDbUser';
\n const DB_PASSWORD = '$PASS2';" > /var/www/include/config/db.inc.php

echo "=> Done!"
#echo "========================================================================"
#echo "You can now connect to this MySQL Server using:"
#echo ""
#echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
#echo ""
#echo "Please remember to change the above password as soon as possible!"
#echo "MySQL user 'root' has no password but only allows local connections"
#echo "========================================================================"

mysqladmin -uroot shutdown
