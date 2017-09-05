#!/bin/bash

set -x
database_name=qloapps
database_user=qloappsuser
database_user_password=`date | md5sum | fold -w 12 | head -n 1`


database_availability_check=`mysqlshow --user=root | grep -o $database_name`
if [ "$database_availability_check" == "$database_name" ]; then
exit 1
else
mysql -u root -e "create database $database_name;" 
mysql -u root -e "grant all on $database_name.* to '$database_user'@'%' identified by '$database_user_password';"
echo "Your database user "$database_user" password is "$database_user_password"" > /var/log/check.log
fi
