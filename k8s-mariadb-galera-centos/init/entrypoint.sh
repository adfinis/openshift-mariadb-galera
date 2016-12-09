#!/bin/bash

set -e
set -x

EXTRA_DEFAULTS_FILE="/etc/mysql/my-galera.cnf"
FIRST_TIME_SQL="/tmp/mysql-first-time.sql"
MYSQLD_FLAGS=""


# find our peers
if [ -z "$POD_NAMESPACE" ]; then
	echo "POD_NAMESPACE not set, spin up single node"
else
	echo "Galera: Finding peers"
	MYSQLD_FLAGS+="--defaults-extra-file=/etc/mysql/my-galera.cnf "
	cp /init/my-galera.cnf /etc/mysql
	/init/peer-finder -on-start="/init/configure-galera.sh" -service=galera
fi


# if mysql is not yet configured, do so
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "CONFIGURE MYSQL"
	/init/configure-mysql.sh "$FIRST_TIME_SQL"
	MYSQLD_FLAGS+="--init-file=$FIRST_TIME_SQL "
fi

exec mysqld $MYSQLD_FLAGS
