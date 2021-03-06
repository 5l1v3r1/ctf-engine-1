FROM ubuntu:14.04

MAINTAINER Breno Tamburi <c0r1ng4@rtfm-ctf.org>

ENV SERVERNAME SERVER_NAME
ENV EMAILADM EMAIL_ADM

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install supervisor git curl apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-curl && echo "ServerName localhost" >> /etc/apache2/apache2.conf && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

ADD ctf-lamp/start-apache2.sh /start-apache2.sh
ADD ctf-lamp/start-mysqld.sh /start-mysqld.sh
ADD ctf-lamp/run.sh /run.sh
RUN chmod 755 /*.sh
ADD ctf-lamp/my.cnf /etc/mysql/conf.d/my.cnf
ADD ctf-lamp/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD ctf-lamp/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

ADD ctf-lamp/databases /root/mysql
ADD ctf-lamp/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD ctf-lamp/config_apache.sh /config_apache.sh
RUN chmod 755 /*.sh

ADD ctf-lamp/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && a2enmod ssl

ADD ctf-web /app
RUN mkdir -p /app && rm -fr /var/www && ln -s /app /var/www
RUN mkdir -p /ctf-config && ln -s /app /ctf-config

ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

RUN cd /app && composer install
RUN chown -R www-data:www-data /var/www/writable

WORKDIR /
RUN ./create_mysql_admin_user.sh
RUN ./config_apache.sh ${SERVER_NAME} ${EMAIL_ADM}

VOLUME ["/ctf-config"]

EXPOSE 80 3306

CMD ["/run.sh"]
