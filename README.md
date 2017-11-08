# Fabric.Docker.InterfaceEngine
Docker for interface engine to use for [Fabric.Realtime](https://github.com/HealthCatalyst/Fabric.Realtime).

This image delivers Mirth Connect on Linux and includes configurable scripts to switch Mirth Connect's internal database (Apache Derby) to an external SQL Server with trusted authentication using Microsoft's JDBC Client and Kerberos.

This image also contains a simple HL7 V2 channel reader that parses common HL7 header information, transforms the message to XML and writes the entire payload to an AMQP-enabled message exchange.

## Run Fabric.Docker.InterfaceEngine

Standalone (Derby)
```
docker run -d -p 8080:8080 -p 8443:8443 -p 6661:6661 --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine
```

Using MySQL:
```
docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 -e MYSQL_USER2=<mysqluser> -e MYSQL_PASSWORD=<mysqlpassword> --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine
```

## Switch Mirth Connect's Internal Database to an External SQL Server

To switch Mirth Connect's internal database to an external SQL Server using integrated security, the interface engine must be running on a docker host whose time is in sync with an Active Directory domain controller. In addition, the db_catalog must already be created on the db_host. And the user must have permissions to read, write, and administer ddl on that db_catalog. To switch, execute the following script with the seven required parameters:

```
$ docker exec [container_id | container_name] /opt/mirthconnect_database/switchtosqlserver.sh $user(lowercase) $password $fqdn $kdc_hostname $db_hostname $db_port $db_catalog
```

If Kerberos authentication is successful, the output will include the following three lines:

```
Connecting to database...
Authentication Scheme: KERBEROS
Disconnected from database.
```

Finally, the script will restart Mirth Connect. The external database will then show Mirth Connect's internal tables (i.e dbo.CHANNEL).


## Deploy Simple HL7 V2 Channel Reader with AMQP-enabled Message Destination

This image has baked into it an XML file defining a simple Mirth Connect channel that listens to incoming messages on a Channel Reader and writes messages to a message exchange defined by four Configuration Map Keys. This channel, _Realtime_HL7V2_Processor_ is automatically deployed as part of the image.

### Configure Destination Exchange

The AMQP-enabled client is powered by RabbitMQ's Java client library, which is also baked into this image. The four Configuration Map Keys have the following default values:

* AMQP_EXCHANGE_NAME = fabric.realtime.hl7
* AMQP_EXCHANGE_TYPE = topic
* AMQP_HOST = rabbitmq
* AMQP_PORT = 5672

To tailor the destination exchange to suit your environment, login to the Mirth Connect Administrator and alter the values in **Mirth Connect** > **Settings** > **Configuration Map**.
