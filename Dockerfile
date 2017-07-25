FROM centos:centos7

MAINTAINER Health Catalyst <marshall.pettit@healthcatalyst.com>

# Install required packages
RUN yum install -y wget krb5-libs krb5-workstation ntp rsync dos2unix; yum clean all

# Install Java
# RUN yum -y install java-1.8.0-openjdk; yum clean all

RUN wget -O jdk.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.rpm \
&& yum install -y ./jdk.rpm \
&& yum clean all \
&& rm -f jdk.rpm

# Install Mirth-Connect
RUN wget -O mirthconnect.rpm http://downloads.mirthcorp.com/connect/3.4.2.8129.b167/mirthconnect-3.4.2.8129.b167-linux.rpm \
&& yum install -y mirthconnect.rpm \
&& yum clean all \
&& rm -f mirthconnect.rpm 

# Install Microsoft JDBC Driver
RUN wget -O - https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/enu/sqljdbc_6.0.8112.100_enu.tar.gz \
| tar xz \
&& cp sqljdbc_6.0/enu/jre8/sqljdbc42.jar /opt/mirthconnect/custom-lib \
&& rm -rf sqljdbc_6.0 \
; sed -i '/<\/drivers>/ i\ \t<driver class="com.microsoft.sqlserver.jdbc.SQLServerDriver" name="MS SQL Server" template="jdbc:sqlserver://host:port;databaseName=dbname" selectLimit="SELECT TOP 1 * FROM ?" />' /opt/mirthconnect/conf/dbdrivers.xml

ADD conf/startmirthandrenewcredentials.sh /opt/mirthconnect/startmirthandrenewcredentials.sh

RUN dos2unix /opt/mirthconnect/startmirthandrenewcredentials.sh \
    && chmod +x /opt/mirthconnect/startmirthandrenewcredentials.sh

EXPOSE 8080 8443

# Start Mirth-Connect as a service
ENTRYPOINT ["/opt/mirthconnect/startmirthandrenewcredentials.sh"]
