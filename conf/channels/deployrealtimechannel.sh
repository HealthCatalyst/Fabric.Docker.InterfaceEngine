#!/bin/bash

cd /opt/mirthconnect/

# http://www.mirthcorp.com/community/wiki/display/mirthuserguidev1r8p0/Mirth+Shell

url="https://127.0.0.1"

if [[ ! -z "${HTTPS_PORT:-}" ]]; then
    url="${url}:${HTTPS_PORT}"
else
    url="${url}:8443"
fi


if [[ ! -z "${HTTP_CONTEXTPATH:-}" ]]; then
    url="${url}${HTTP_CONTEXTPATH}"
fi

java -cp "." -jar mirth-cli-launcher.jar -a $url -s /opt/mirthconnect_channels/mirth-cli-deployrealtimechannel
echo "Installed Realtime_HL7V2_Processor."

java -cp "." -jar mirth-cli-launcher.jar -a $url -s /opt/mirthconnect_channels/mirth-cli-deploytcpreceiverchannel
echo "Installed TCP_Receiver_Channel."
