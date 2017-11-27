#!/bin/bash

cd /opt/mirthconnect/

java -cp "." -jar mirth-cli-launcher.jar -s /opt/mirthconnect_channels/mirth-cli-deployrealtimechannel
echo "Installed Realtime_HL7V2_Processor."

java -cp "." -jar mirth-cli-launcher.jar -s /opt/mirthconnect_channels/mirth-cli-deploytcpreceiverchannel
echo "Installed TCP_Receiver_Channel."
