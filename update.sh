#!/bin/bash

set -u

##set user password
user=qloapps

echo -e "$USER_PASSWORD\n$USER_PASSWORD" | passwd $user
echo "User qloapps password updated"

##set mysql password

sleep 4
database_connectivity_check=no
var=1
while [ "$database_connectivity_check" != "mysql" ]; do
/etc/init.d/mysql start
sleep 2
database_connectivity_check=`mysqlshow --user=root | grep -o mysql`
if [ $var -ge 4 ]; then
exit 1
fi
var=$((var+1))
done
 
database_availability_check=`mysqlshow --user=root | grep -ow "$MYSQL_DATABASE"`
 
if [ "$database_availability_check" == "$MYSQL_DATABASE" ]; then
exit 1
else
mysqladmin -u root password $MYSQL_ROOT_PASSWORD
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "grant all on *.* to 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "create database $MYSQL_DATABASE;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "grant all on $MYSQL_DATABASE.* to 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD';"
supervisorctl stop update_credentials && supervisorctl remove update_credentials
echo "Database $MYSQL_DATABASE created"
fi
