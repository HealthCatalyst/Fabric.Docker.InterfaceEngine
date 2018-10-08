#!/bin/bash

# usage: ./switchtosqlserver.sh username password domain kdc database port catalog

# capture parameters
username=$1
password=$2
domain=$3
ad_hostname=$4
db_hostname=$5
db_port=$6
db_catalog=$7

if [[ -z "$db_catalog" ]]; then
  echo "Usage: switchtosqlserver.sh username password domain kdc database port catalog"
  exit 1
fi

# echo parameters
echo "Username: $username"
echo "Domain: $domain"
echo "Domain Controller: $ad_hostname"
echo "Database Server: $db_hostname"
echo "Database Port: $db_port"
echo "Database Catalog: $db_catalog"

# make lowercase and uppercase
username_lc="${username,,}"
domain_lc="${domain,,}"
domain_uc="${domain^^}"

# find and replace values in config files with parameters
sed -i 's/$domain/'"$domain_lc"'/g' /opt/mirthconnect_database/krb5.conf
sed -i 's/$DOMAIN/'"$domain_uc"'/g' /opt/mirthconnect_database/krb5.conf
sed -i 's/$server/'"$ad_hostname"'/g' /opt/mirthconnect_database/krb5.conf

sed -i 's/$username/'"$username_lc"'/g' /opt/mirthconnect_database/SQLJDBCDriver.conf
sed -i 's/$DOMAIN/'"$domain_uc"'/g' /opt/mirthconnect_database/SQLJDBCDriver.conf

sed -i 's/$Server/'"$db_hostname"'/g' /opt/mirthconnect_database/mirth.properties
sed -i 's/$Port/'"$db_port"'/g' /opt/mirthconnect_database/mirth.properties
sed -i 's/$Domain/'"$domain"'/g' /opt/mirthconnect_database/mirth.properties
sed -i 's/$Database/'"$db_catalog"'/g' /opt/mirthconnect_database/mirth.properties

sed -i 's/$Server/'"$db_hostname"'/g' /opt/mirthconnect_database/KerberosAuthenticationTest.java
sed -i 's/$Port/'"$db_port"'/g' /opt/mirthconnect_database/KerberosAuthenticationTest.java
sed -i 's/$Domain/'"$domain"'/g' /opt/mirthconnect_database/KerberosAuthenticationTest.java
sed -i 's/$Database/'"$db_catalog"'/g' /opt/mirthconnect_database/KerberosAuthenticationTest.java

# swap Mirth Connect config files
cp /opt/mirthconnect_database/krb5.conf /etc/krb5.conf
cp /opt/mirthconnect_database/SQLJDBCDriver.conf /opt/mirthconnect/conf/SQLJDBCDriver.conf
cp /opt/mirthconnect_database/mirth.properties /opt/mirthconnect/conf/mirth.properties
cp /opt/mirthconnect_database/mcservice /opt/mirthconnect/mcservice
cp /opt/mirthconnect_database/mcservice.vmoptions /opt/mirthconnect/mcservice.vmoptions

# create keytab file
ktutil <<EOF
addent -password -p $username@$domain_uc -k 1 -e RC4-HMAC
$password
wkt /opt/mirthconnect/conf/mirth.keytab
quit
EOF

# generate TGT
kinit $username_lc@$domain_uc -k -t /opt/mirthconnect/conf/mirth.keytab
klist

# test integrated security
cd /opt/mirthconnect_database/
javac KerberosAuthenticationTest.java
java -cp ".:/opt/mirthconnect/custom-lib/sqljdbc42.jar" -Djava.security.auth.login.config=/opt/mirthconnect/conf/SQLJDBCDriver.conf -Djava.security.krb5.conf=/etc/krb5.conf KerberosAuthenticationTest

echo "result: $?"
echo "Done testing database"

# restart Mirth Connect
# sh /opt/mirthconnect/mcservice restart

echo "finished switching to SQL Server"