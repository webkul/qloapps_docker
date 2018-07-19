FROM ubuntu:14.04
 
LABEL maintainer="Alankrit Srivastava <alankrit.srivastava256@webkul.com>"

ARG user=qloapps

##Update server and install lamp server
RUN apt-get update \
    && apt-get -y install apache2 \
    && a2enmod rewrite \
    && a2enmod headers \
    && export LANG=en_US.UTF-8 \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && apt-get install -y language-pack-en-base \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get -y install php5.6 php5.6-curl php5.6-intl php5.6-gd php5.6-dom php5.6-mcrypt php5.6-iconv php5.6-xsl php5.6-mbstring php5.6-ctype   php5.6-zip php5.6-pdo php5.6-xml php5.6-bz2 php5.6-calendar php5.6-exif php5.6-fileinfo php5.6-json php5.6-mysqli php5.6-mysql php5.6-posix php5.6-tokenizer php5.6-xmlwriter php5.6-xmlreader php5.6-phar php5.6-soap php5.6-mysql php5.6-fpm php5.6-bcmath libapache2-mod-php5.6 \
    && sed -i -e"s/^memory_limit\s*=\s*128M/memory_limit = 512M/" /etc/php/5.6/apache2/php.ini \
    && echo "date.timezone = Asia/Kolkata" >> /etc/php/5.6/apache2/php.ini \
    && sed -i -e"s/^upload_max_filesize\s*=\s*2M/upload_max_filesize = 16M/" /etc/php/5.6/apache2/php.ini \
    && sed -i -e"s/^max_execution_time\s*=\s*30/max_execution_time = 500/" /etc/php/5.6/apache2/php.ini \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.6 \
    && apt-get install -y git nano curl openssh-server \
##setup non root user
    && useradd -m -s /bin/bash ${user} \
    && mkdir -p /home/${user}/www \
##Download Qloapps latest version
    && cd /home/${user}/www && git clone https://github.com/webkul/hotelcommerce.git \
##change file permission and ownership
    && find /home/${user}/www -type f -exec chmod 644 {} \; \
    && find /home/${user}/www -type d -exec chmod 755 {} \; \
    && chown -R ${user}: /home/${user}/www \
    && sed -i "s@www-data@${user}@g" /etc/apache2/envvars \
    && echo ' <Directory /home/> \n\
                Options FollowSymLinks \n\  
                Require all granted  \n\
                AllowOverride all \n\
                </Directory>  ' >> /etc/apache2/apache2.conf \
    && sed -i "s@/var/www/html@/home/${user}/www/hotelcommerce@g" /etc/apache2/sites-enabled/000-default.conf \
##install supervisor and setup supervisord.conf file
    && apt-get install -y supervisor \
    && mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY update.sh /etc/update.sh
RUN chmod a+x /etc/update.sh 
WORKDIR /home/${user}/www/hotelcommerce

EXPOSE 3306 80 443

CMD ["/usr/bin/supervisord"] 
