From ubuntu:14.04

MAINTAINER Nitin Agnihotri <nitin124@webkul.com>

##update server and install apache

RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN apt-get -y install apache2 makepasswd


RUN mkdir -p /var/lock/apache2 /var/run/apache2

## install php and its dependencies

RUN apt-get -y install php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-gd php5-curl php5-mcrypt

RUN a2enmod php5

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt

##install mysql-server

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server 

ADD my.cnf /etc/mysql/conf.d/my.cnf

##install supervisor and setup supervisord.conf file

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor
 
RUN mkdir -p /var/log/supervisor
 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
 
##Copy your apache configuration file

RUN rm /etc/apache2/sites-available/000-default.conf

COPY 000-default.conf /etc/apache2/sites-available/

##Install Git

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git

## clone qloapps from github

RUN rm -f /var/www/html/*

RUN cd /var/www/html && git clone https://github.com/webkul/hotelcommerce.git .

## manage php memory and date-timezone setttings

##change ownership and permissions

RUN chown -R www-data:www-data /var/www/html

RUN find /var/www/html/ -type f -exec chmod 644 {} \;

RUN find /var/www/html/ -type d -exec chmod 755 {} \;

RUN DEBIAN_FRONTEND=noninteractive a2enmod rewrite

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt

RUN DEBIAN_FRONTEND=noninteractive a2enmod headers

ADD startupscript.sh /var/www/startupscript.sh

ADD start-apache2.sh /var/www/start-apache2.sh

ADD start-mysqld.sh /var/www/start-mysqld.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD create_mysql_admin_user.sh /var/www/create_mysql_admin_user.sh

RUN apt-get install pwgen

RUN chmod 755 /var/www/*.sh

RUN rm -rf /var/lib/mysql/*

EXPOSE 80

EXPOSE 3306

## This command will run inside the container when container gets launched

CMD ["/var/www/startupscript.sh"]


