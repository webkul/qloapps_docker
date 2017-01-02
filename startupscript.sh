#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    rm /etc/mysql/conf.d/mysqld_safe_syslog.cnf    
    cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /var/www/create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

exec supervisord -n
