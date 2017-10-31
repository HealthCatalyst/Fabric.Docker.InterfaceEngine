#!/bin/bash

set -eu

# set -x

if [[ ! -z "${SQLSERVER_USER:-}" ]] || [[ ! -z "${SQLSERVER_USER_FILE:-}" ]]
then

    echo "SQLSERVER_USER is set so switching Mirth to use MS SQL Server"

    if [[ ! -z "${SQLSERVER_USER_FILE:-}" ]]
    then
        echo "SQLSERVER_USER_FILE is set so reading from $SQLSERVER_USER_FILE"
        SQLSERVER_USER=$(cat $SQLSERVER_USER_FILE)
    fi 
    if [[ -z "${SQLSERVER_USER:-}" ]]; then
        echo "SQLSERVER_USER must be specified"
        exit 1
    fi    

    if [[ ! -z "${SQLSERVER_PASSWORD_FILE:-}" ]]
    then
        echo "SQLSERVER_PASSWORD_FILE is set so reading from $SQLSERVER_PASSWORD_FILE"
        SQLSERVER_PASSWORD=$(cat $SQLSERVER_PASSWORD_FILE)
    fi 
    if [[ -z "${SQLSERVER_PASSWORD:-}" ]]; then
        echo "SQLSERVER_PASSWORD must be specified"
        exit 1
    fi

    if [[ ! -z "${SQLSERVER_DOMAIN_FILE:-}" ]]
    then
        echo "SQLSERVER_DOMAIN_FILE is set so reading from $SQLSERVER_DOMAIN_FILE"
        SQLSERVER_DOMAIN=$(cat $SQLSERVER_DOMAIN_FILE)
    fi 
    if [[ -z "${SQLSERVER_DOMAIN:-}" ]]; then
        echo "SQLSERVER_DOMAIN must be specified"
        exit 1
    fi    

    if [[ ! -z "${SQLSERVER_AD_URL_FILE:-}" ]]
    then
        echo "SQLSERVER_AD_URL_FILE is set so reading from $SQLSERVER_AD_URL_FILE"
        SQLSERVER_AD_URL=$(cat $SQLSERVER_AD_URL_FILE)
    fi 
    if [[ -z "${SQLSERVER_AD_URL:-}" ]]; then
        echo "SQLSERVER_AD_URL must be specified"
        exit 1
    fi    

    if [[ ! -z "${SQLSERVER_SERVER_FILE:-}" ]]
    then
        echo "SQLSERVER_SERVER_FILE is set so reading from $SQLSERVER_SERVER_FILE"
        SQLSERVER_SERVER=$(cat $SQLSERVER_SERVER_FILE)
    fi 
    if [[ -z "${SQLSERVER_SERVER:-}" ]]; then
        echo "SQLSERVER_SERVER must be specified"
        exit 1
    fi    

    if [[ ! -z "${SQLSERVER_DATABASE_FILE:-}" ]]
    then
        echo "SQLSERVER_DATABASE_FILE is set so reading from $SQLSERVER_DATABASE_FILE"
        SQLSERVER_DATABASE=$(cat $SQLSERVER_DATABASE_FILE)
    fi 
    if [[ -z "${SQLSERVER_DATABASE:-}" ]]; then
        echo "SQLSERVER_DATABASE must be specified"
        exit 1
    fi    

    # now run with all the parameters
    /opt/mirthconnect_database/switchtosqlserver.sh ${SQLSERVER_USER} ${SQLSERVER_PASSWORD} ${SQLSERVER_DOMAIN} ${SQLSERVER_AD_URL} ${SQLSERVER_SERVER} ${SQLSERVER_PORT:-1433} ${SQLSERVER_DATABASE}

else
    if [[ ! -z "${MYSQL_USER:-}" ]]; then
        echo "$MYSQL_USER is set so switching Mirth to use MySql"

        /opt/mirthconnect_mysql/switchtomysql.sh
    fi
fi

/opt/mirthconnect/startmirthandrenewcredentials.sh

echo "starting Mirth"

exec "$@"
