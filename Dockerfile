### DO NOT SKIP OR REMOVE ANY STEP UNLESS YOU HAVE PROPER REASONS TO DO SO ### 

From ubuntu:14.04

MAINTAINER Alankrit Srivastava alankrit.srivastava256@webkul.com

## UPDATE SERVER AND INSTALL LAMP SERVER

RUN apt-get update \

&& apt-get -y install apache2 \
&& apt-get install -y php5 php5-curl php5-gd php5-mcrypt php5-mysql libapache2-mod-php5 \
&& sed -i -e"s/^memory_limit\s*=\s*128M/memory_limit = 512M/" /etc/php5/apache2/php.ini \
&& php5enmod mcrypt \

&& echo '<Directory /var/www/html/> \n\
            Options Indexes FollowSymLinks MultiViews \n\
            AllowOverride All \n\
            Require all granted \n\
            </Directory> ' >> /etc/apache2/apache2.conf \

&& echo ' <VirtualHost *:80> \n\
#ServerName  \n\
DocumentRoot /var/www/html/hotelcommerce-1.1.0 \n\
<Directory  /var/www/html/hotelcommerce-1.1.0> \n\
Options FollowSymLinks \n\
Require all granted  \n\
AllowOverride all \n\
</Directory> \n\
ErrorLog /var/log/apache2/error.log \n\
CustomLog /var/log/apache2/access.log combined \n\
</VirtualHost> ' > /etc/apache2/sites-enabled/000-default.conf \

&& rm /var/www/html/* \

&& DEBIAN_FRONTEND=noninteractive apt-get -y install unzip wget\

&& DEBIAN_FRONTEND=noninteractive  apt-get install -y mysql-server-5.6 \

&& sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf \

&& apt-get install -y supervisor \
  
&& mkdir -p /var/log/supervisor \

&& cd /opt && wget https://github.com/webkul/hotelcommerce/archive/v1.1.0.zip \

&& cd /var/www/html && unzip /opt/v1.1.0.zip \

&& find /var/www/html/ -type f -exec chmod 644 {} \; \

&& find /var/www/html/ -type d -exec chmod 755 {} \; \

&& chown -R www-data: /var/www/html/ 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY mysql.sh /etc/mysql.sh

RUN chmod a+x /etc/mysql.sh


EXPOSE 3306 80 443

CMD ["/usr/bin/supervisord"] 


