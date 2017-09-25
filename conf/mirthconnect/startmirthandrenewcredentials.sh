#!/bin/bash

echo "starting mirth"

/opt/mirthconnect/mcservice start

echo "sleeping until mirth connect is running"
until [ "`/opt/mirthconnect/mcservice status`"=="The daemon is running." ]; do sleep 1s; echo "`/opt/mirthconnect/mcservice status`"; done;

echo "finished sleeping since mirthconnect is running"

echo "==== calling web admin interface to see if it is up ===="

declare -i c=0
c=0
protocol="https"

# disable set -e so the script does not break when there is an error with curl
set +e

while [ $c -lt 60 ]; do
    echo "curl -X GET $protocol://localhost:8443"
    curl -X GET $protocol://localhost:8443 -k
    RETVAL=$?
    echo "RETVAL:[$RETVAL]"
    if [ $RETVAL -eq 0 ]; then 
      break 
    fi    
    c=$c+1
    echo "Trying again [$c]"
    sleep 1s
done

set -e

# echo "sleeping for 60s before setting up channels"
# sleep 60s;

echo "setting up channels"
/opt/mirthconnect_channels/deployrealtimechannel.sh

echo "done setting up channels"

while :; do
  for CACHE_FILE in $( find /tmp -maxdepth 1 -type f -name 'krb5cc*' ); do

    echo "Processing file"

    echo "Processing $($CACHE_FILE)"
    # Find the current owner and group of the ticket cache
    OWNER=$( ls -n $CACHE_FILE | awk '{print $3}' )
    GROUP=$( ls -n $CACHE_FILE | awk '{print $4}' )

    # Find the expirey time of the ticket granting ticket
    EXPIRE_TIME=$( date -d "$( klist -c $CACHE_FILE | grep krbtgt | awk '{print $3, $4}' )" +%s )

    # If ticket is about to expire, remove and recreate it
    if [ $( date +%s ) -ge $EXPIRE_TIME ]; then
      kdestroy -c $CACHE_FILE &> /dev/null
      echo "$(date): Removed expired ticket cache ($CACHE_FILE) for user $OWNER"
      # Separate install script will replace username@domain with parameterized values
          kinit -k -t /opt/mirthconnect/conf/mirth.keytab username@domain
          echo "$(date): Created new ticket cache for username@domain"

    # Otherwise renew it
    elif [ $( expr $EXPIRE_TIME - $( date +%s ) ) -le 300 ]; then
      kinit -R -c $CACHE_FILE &> /dev/null
      if [ $? -ne 0 ]; then
        echo "$(date): An error occurred renewing $CACHE_FILE"
      else
        chown $OWNER:$GROUP $CACHE_FILE &> /dev/null
        echo "$(date): Renewed ticket cache ($CACHE_FILE) for user $OWNER"
      fi
    fi
  done
  # Wait for a minute
  sleep 60
done

echo "finished running script"

