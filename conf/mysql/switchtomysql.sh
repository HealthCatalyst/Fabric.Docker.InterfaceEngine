#!/bin/bash

echo "switching to use MySql"

# https://stackoverflow.com/questions/5955548/how-do-i-use-sed-to-change-my-configuration-files-with-flexible-keys-and-values

sed -i "s/^\(database\s*=\s*\).*\$/\1mysql/" /opt/mirthconnect/conf/mirth.properties

mysqlurl="jdbc:mysql://localhost:3306/mirthdb"
sed -i "s/^\(database.url\s*=\s*\).*\$/\1$mysqlurl/" /opt/mirthconnect/conf/mirth.properties

mysqlusername=$MYSQL_USERNAME
mysqlpassword=$MYSQL_PASSWORD
sed -i "s/^\(database.username\s*=\s*\).*\$/\1$mysqlusername/" /opt/mirthconnect/conf/mirth.properties
sed -i "s/^\(database.password\s*=\s*\).*\$/\1$mysqlpassword/" /opt/mirthconnect/conf/mirth.properties


echo "finished updating the config"