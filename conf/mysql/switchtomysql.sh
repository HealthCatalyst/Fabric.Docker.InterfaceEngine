#!/bin/bash

echo "switching to use MySql"

# https://stackoverflow.com/questions/5955548/how-do-i-use-sed-to-change-my-configuration-files-with-flexible-keys-and-values

replaceconfig "database" "mysql" /opt/mirthconnect/conf/mirth.properties
# sed -i "s/^\(database\s*=\).*\$/\1 mysql/" /opt/mirthconnect/conf/mirth.properties

mirthdb=${MYSQL_DATABASE:-mirthdb}
mysqlport=${MYSQL_PORT:-3306}

replaceconfig "database.url" "jdbc\:mysql\:\/\/mysqlserver\:$mysqlport/$mirthdb" /opt/mirthconnect/conf/mirth.properties
# sed -i "s#^\(database.url\s*=*\).*\$#\1 jdbc\:mysql\:\/\/mysqlserver\:3306/mirthdb#" 

mysqlusername=$MYSQL_USER
mysqlpassword=$MYSQL_PASSWORD
replaceconfig "database.username" "$mysqlusername" /opt/mirthconnect/conf/mirth.properties
replaceconfig "database.password" "$mysqlpassword" /opt/mirthconnect/conf/mirth.properties

# sed -i "s#^\(database.username\s*=\).*\$#\1 $mysqlusername#" /opt/mirthconnect/conf/mirth.properties
# sed -i "s#^\(database.password\s*=\).*\$#\1 $mysqlpassword#" /opt/mirthconnect/conf/mirth.properties

echo "finished updating the config: mirth.properties"
