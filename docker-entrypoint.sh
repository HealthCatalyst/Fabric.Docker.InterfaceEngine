#!/bin/bash

set -eu

# set -x

if [[ ! -z "${SQLSERVER_USER:-}" ]]; then
    echo "SQLSERVER_USER is set so switching Mirth to use MySql"

    sqlserveruser=${SQLSERVER_USER}

    if [[ ! -z "${SQLSERVER_PASSWORD_FILE:-}" ]]
    then
        echo "SQLSERVER_PASSWORD_FILE is set so reading from $SQLSERVER_PASSWORD_FILE"
        SQLSERVER_PASSWORD=$(cat $SQLSERVER_PASSWORD_FILE)
    fi 
    if [[ -z "${SQLSERVER_PASSWORD:-}" ]]; then
        echo "SQLSERVER_PASSWORD must be specified"
        exit 1
    fi
    sqlserverpassword=${SQLSERVER_PASSWORD}

    if [[ -z "${SQLSERVER_DOMAIN:-}" ]]; then
        echo "SQLSERVER_DOMAIN must be specified"
        exit 1
    fi
    domain=${SQLSERVER_DOMAIN}
    if [[ -z "${SQLSERVER_AD_URL:-}" ]]; then
        echo "SQLSERVER_AD_URL must be specified"
        exit 1
    fi
    adserver=${SQLSERVER_AD_URL}
    if [[ -z "${SQLSERVER_SERVER:-}" ]]; then
        echo "SQLSERVER_DOMAIN must be specified"
        exit 1
    fi
    sqlserver=${SQLSERVER_SERVER}
    sqlserverport=${SQLSERVER_PORT:-1433}

    if [[ -z "${SQLSERVER_DATABASE:-}" ]]; then
        echo "SQLSERVER_DATABASE must be specified"
        exit 1
    fi
    sqlserverdatabase=${SQLSERVER_DATABASE}

    /opt/mirthconnect_database/switchtosqlserver.sh $sqlserveruser $sqlserverpassword $domain $adserver $sqlserver $sqlserverport $sqlserverdatabase
else
    if [[ ! -z "${MYSQL_USER:-}" ]]; then
        echo "$MYSQL_USER is set so switching Mirth to use MySql"

        /opt/mirthconnect_mysql/switchtomysql.sh
    fi
fi


/opt/mirthconnect/startmirthandrenewcredentials.sh

echo "starting final"

exec "$@"
