# Fabric.Docker.InterfaceEngine

[Mirth Connect](https://www.mirth.com/) interface engine Docker instance for use with the [Health Catalyst](https://www.healthcatalyst.com) [Fabric.Realtime](https://github.com/HealthCatalyst/Fabric.Realtime) platform.

This image delivers Mirth Connect on Linux and includes configurable scripts to switch Mirth Connect's internal database (Apache Derby) to an external SQL Server with trusted authentication using Microsoft's JDBC Client and Kerberos.

This image also contains a simple HL7 V2 channel reader that parses common HL7 header information, transforms the message to XML and writes the entire payload to an AMQP-enabled message exchange.

# Deployment

As this image is intended for deployment as part of the Fabric.Realtime platform, please refer to the set of instructions at https://github.com/HealthCatalyst/Fabric.Realtime.

# Switch Mirth Connect's Internal Database to an External SQL Server
To use Microsoft SQL Server instead of the embedded MySql, set the following environment variables:
SQLSERVER_USER
SQLSERVER_PASSWORD
SQLSERVER_DOMAIN
SQLSERVER_AD_URL
SQLSERVER_SERVER
SQLSERVER_DATABASE

or for a more security, pass them as secrets:
SQLSERVER_USER_FILE
SQLSERVER_PASSWORD_FILE
SQLSERVER_DOMAIN_FILE
SQLSERVER_AD_URL_FILE
SQLSERVER_SERVER_FILE
SQLSERVER_DATABASE_FILE

# HL7 V2 Channel Reader with AMQP-enabled Message Destination

This image has baked into it an XML file defining a simple Mirth Connect channel that listens to incoming messages on a Channel Reader and writes messages to a message exchange defined by four Configuration Map Keys. This channel, _Realtime_HL7V2_Processor_ is automatically deployed as part of the image.

## Configure Destination Exchange

The AMQP-enabled client is powered by RabbitMQ's Java client library, which is also baked into this image. The four Configuration Map Keys have the following default values:

* AMQP_EXCHANGE_NAME = fabric.realtime.hl7
* AMQP_EXCHANGE_TYPE = topic
* AMQP_HOST = rabbitmq
* AMQP_PORT = 5672

To tailor the destination exchange to suit your environment, login to the Mirth Connect Administrator and alter the values in **Mirth Connect** > **Settings** > **Configuration Map**.
