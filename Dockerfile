FROM centos:centos7

MAINTAINER Health Catalyst <marshall.pettit@healthcatalyst.com>

# Install required packages
RUN yum install -y wget krb5-libs krb5-workstation ntp rsync; yum clean all

# Install Java
RUN wget -O jdk.rpm --continue --no-check-certificate --no-cookies --verbose --header 'Cookie: oraclelicense=accept-securebackup-cookie' \
http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.rpm \
&& yum install -y ./jdk.rpm \
&& yum clean all \
&& rm -f jdk.rpm

# Install Mirth-Connect
RUN wget -O mirthconnect.rpm http://downloads.mirthcorp.com/connect/3.4.2.8129.b167/mirthconnect-3.4.2.8129.b167-linux.rpm \
&& yum install -y mirthconnect.rpm \
&& yum clean all \
&& rm -f mirthconnect.rpm \
&& wget -SSL -O /opt/mirthconnect/startmirthandrenewcredentials.sh \ https://raw.githubusercontent.com/HealthCatalyst/Fabric.Realtime/master/Fabric.Realtime.Docker.MirthConnect/conf/startmirthandrenewcredentials.sh \
&& chmod +x /opt/mirthconnect/startmirthandrenewcredentials.sh

# Install Microsoft JDBC Driver
RUN wget -O - https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/enu/sqljdbc_6.0.8112.100_enu.tar.gz \
| tar xz \
&& cp sqljdbc_6.0/enu/jre8/sqljdbc42.jar /opt/mirthconnect/custom-lib \
&& rm -rf sqljdbc_6.0 \
; sed -i '/<\/drivers>/ i\ \t<driver class="com.microsoft.sqlserver.jdbc.SQLServerDriver" name="MS SQL Server" template="jdbc:sqlserver://host:port;databaseName=dbname" selectLimit="SELECT TOP 1 * FROM ?" />' /opt/mirthconnect/conf/dbdrivers.xml

# Start Mirth-Connect as a service
ENTRYPOINT ["/opt/mirthconnect/startmirthandrenewcredentials.sh"]
