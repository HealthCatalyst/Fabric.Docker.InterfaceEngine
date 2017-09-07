#!/bin/bash

cd /opt/mirthconnect/

result=$(java -cp "." -jar mirth-cli-launcher.jar -s /opt/mirthconnect_channels/mirth-cli-getchannellist | grep Realtime_HL7V2_Processor | wc -l)
if [ $result -gt 0 ]; then
  echo "Realtime_HL7V2_Processor is already installed."
else
  java -cp "." -jar mirth-cli-launcher.jar -s /opt/mirthconnect_channels/mirth-cli-deployrealtimechannel
  echo "Installed Realtime_HL7V2_Processor."
fi
