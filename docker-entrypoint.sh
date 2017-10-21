#!/bin/bash

set -eu

if [[ ! -z "${MYSQL_USER:-}" ]]; then
    echo "$MYSQL_USER is set so switching Mirth to use MySql"

    /opt/mirthconnect_mysql/switchtomysql.sh
fi

/opt/mirthconnect/startmirthandrenewcredentials.sh

exec "$@"
