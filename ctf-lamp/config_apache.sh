#!/bin/bash


SERVERNAME=$1
EMAIL_ADM=$2


sed -i s/yourdomain.com/$SERVERNAME/g /etc/apache2/sites-available/000-default.conf
sed -i s/yourdomain.com/$SERVERNAME/g /app/include/config/config.inc.php
sed -i s/contact@yourdomain.com/$EMAIL_ADM/g /etc/apache2/sites-available/000-default.conf

echo "Apache config OK!"