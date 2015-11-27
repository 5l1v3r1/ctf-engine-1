FROM ubuntu:14.04

MAINTAINER Breno Tamburi <c0r1ng4@rtfm-ctf.org>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install supervisor git curl apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-curl && echo "ServerName localhost" >> /etc/apache2/apache2.conf && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
