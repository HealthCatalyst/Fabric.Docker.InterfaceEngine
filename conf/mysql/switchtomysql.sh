#!/bin/bash

echo "switching to use MySql"

mirthdb=${MYSQL_DATABASE:-mirthdb}
mysqlport=${MYSQL_PORT:-3306}

echo "checking if mysql server is available"

wait-for-it mysqlserver:$mysqlport -t 60

# https://stackoverflow.com/questions/5955548/how-do-i-use-sed-to-change-my-configuration-files-with-flexible-keys-and-values

replaceconfig "database" "mysql" /opt/mirthconnect/conf/mirth.properties
# sed -i "s/^\(database\s*=\).*\$/\1 mysql/" /opt/mirthconnect/conf/mirth.properties

replaceconfig "database.url" "jdbc\:mysql\:\/\/mysqlserver\:$mysqlport/$mirthdb" /opt/mirthconnect/conf/mirth.properties
# sed -i "s#^\(database.url\s*=*\).*\$#\1 jdbc\:mysql\:\/\/mysqlserver\:3306/mirthdb#" 

mysqlusername=$MYSQL_USER
mysqlpassword=${MYSQL_PASSWORD:-}
mysqlpasswordfile=${MYSQL_PASSWORD_FILE:-}

if [[ ! -z "$mysqlpasswordfile" ]]
then
    echo "MYSQL_PASSWORD_FILE is set so reading from $mysqlpasswordfile"
    mysqlpassword=`cat $mysqlpasswordfile`
fi

if [[ -z "$mysqlpassword" ]]
then
    echo "Either MYSQL_PASSWORD_FILE or MYSQL_PASSWORD must be set"
    exit 1
fi


replaceconfig "database.username" "$mysqlusername" /opt/mirthconnect/conf/mirth.properties
replaceconfig "database.password" "$mysqlpassword" /opt/mirthconnect/conf/mirth.properties

# sed -i "s#^\(database.username\s*=\).*\$#\1 $mysqlusername#" /opt/mirthconnect/conf/mirth.properties
# sed -i "s#^\(database.password\s*=\).*\$#\1 $mysqlpassword#" /opt/mirthconnect/conf/mirth.properties

echo "finished updating the config: mirth.properties"
