FROM ubuntu:18.04
LABEL maintainer="Siddharth Chouradiya <siddharthchouradiya.cloud360@webkul.com>"
ARG user=qloapps
##Php file configuration with php version
ENV php_version=php7.2 file_uploads=On allow_url_fopen=On memory_limit=512M max_execution_time=240 upload_max_filesize=200M post_max_size=400M max_input_vars=1500
##Update server and install lamp server
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install apache2 \
    && a2enmod rewrite \
    && a2enmod headers \
    && export LANG=en_US.UTF-8 \
    && apt-get install -y software-properties-common \
    && apt-get install -y language-pack-en-base \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y $php_version libapache2-mod-$php_version $php_version-bcmath $php_version-cli $php_version-json $php_version-curl $php_version-fpm $php_version-gd $php_version-ldap $php_version-mbstring $php_version-mysql $php_version-soap $php_version-sqlite3 $php_version-xml $php_version-zip $php_version-intl php-imagick \
    && echo "date.timezone = Asia/Kolkata" >> /etc/php/7.2/apache2/php.ini \
    && sed -i -e 's/memory_limit = .*/memory_limit = '${memory_limit}'/' -e 's/file_uploads = .*/file_uploads = '${file_uploads}'/' -e 's/allow_url_fopen = .*/allow_url_fopen = '${allow_url_fopen}'/' -e 's/max_execution_time = .*/max_execution_time = '${max_execution_time}'/' -e 's/upload_max_filesize = .*/upload_max_filesize = '${upload_max_filesize}'/' -e 's/post_max_size = .*/post_max_size = '${post_max_size}'/' -e 's/max_input_vars = .*/max_input_vars = '${max_input_vars}'/' /etc/php/7.2/apache2/php.ini \
    && apt-get -y install mysql-server-5.7 \
    && apt-get install -y git nano vim curl openssh-server \
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
