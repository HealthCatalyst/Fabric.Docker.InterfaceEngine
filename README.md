# Fabric.Realtime.Docker.InterfaceEngine
Docker for interface engine to use for realtime

This image delivers Mirth Connect on CentOS and includes configurable scripts to switch Mirth Connect's internal database (Apache Derby) to an external SQL Server with trusted authentication using Microsoft's JDBC Client and Kerberos.

This image also contains a simple HL7 V2 channel reader that parses common HL7 header information, transforms the message to XML and writes the entire payload to an AMQP-enabled message exchange.


## Switch Mirth Connect's Internal Database to an External SQL Server

To switch Mirth Connect's internal database to an external SQL Server using integrated security, the interface engine must be running on a docker host whose time is in sync with an Active Directory domain controller. To switch, execute the following script with the seven required parameters:

```
$ docker exec [container_id | container_name] /opt/mirthconnect_database/switchtosqlserver.sh $user $password $fqdn $kdc_hostname $db_hostname $db_port $db_catalog
```

If kerberos authentication is successful, the output will include the following three lines:

```
Connecting to database...
Authentication Scheme: KERBEROS
Disconnected from database.
```

Finally, the script will restart Mirth Connect. The external database will then show Mirth Connect's internal tables (i.e dbo.CHANNEL).


## Deploy Simple HL7 V2 Channel Reader with AMQP-enabled Message Destination

This image has baked into it an XML file defining a simple Mirth Connect channel that listens to incoming messages on a Channel Reader and writes messages to a message exchange defined by four Configuration Map Keys. The following two steps will configure and deploy the channel within Mirth Connect.

### 1. Configure Destination Exchange

The AMQP-enabled client is powered by RabbitMQ's Java client library, which is also baked into this image. The four Configuration Map Keys have the following default values:

* QUEUE_EXCHANGE: "fabric.interfaceengine"
* QUEUE_HOST: "rabbitmq"
* QUEUE_PORT: 5672
* QUEUE_ROUTING_KEY: "mirth.connect.inbound"

To tailor the destination exchange to suit your environment, login to the Mirth Connect Administrator and alter the values in Mirth Connect > Settings > Configuration Map.

### 2. Import and Deploy Channel

Execute the following within the Docker host:

```
$ docker exec [container_id | container_name] /opt/mirthconnect_channels/deployrealtimechannel.sh
```
