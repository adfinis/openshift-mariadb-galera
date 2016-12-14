#!/bin/bash
#
# Adfinis SyGroup AG
# openshift-mariadb-galera: mysql setup script
#

set -e
set -x

if [ -z $1 ]; then
  FIRST_TIME_SQL="/tmp/mysql-first-time.sql"
else
  FIRST_TIME_SQL="$1"
fi


echo 'Running mysql_install_db ...'
mysql_install_db --datadir=/var/lib/mysql
echo 'Finished mysql_install_db'

# These statements _must_ be on individual lines, and _must_ end with
# semicolons (no line breaks or comments are permitted).
# TODO proper SQL escaping on ALL the things D:

cat > "$FIRST_TIME_SQL" <<-EOSQL
-- What's done in this file shouldn't be replicated
--  or products like mysql-fabric won't work
SET @@SESSION.SQL_LOG_BIN=0;

DELETE FROM mysql.user ;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
CREATE USER 'xtrabackup_sst'@'localhost' IDENTIFIED BY 'xtrabackup_sst' ;
GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'xtrabackup_sst'@'localhost' ;


CREATE USER 'readinessProbe'@'127.0.0.1' IDENTIFIED BY 'readinessProbe';
EOSQL


if [ "$MYSQL_DATABASE" ]; then
  echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" >> "$FIRST_TIME_SQL"
fi

if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
  echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$FIRST_TIME_SQL"
  echo "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$FIRST_TIME_SQL"
fi

if [ "$MYSQL_USER" -a ! "$MYSQL_PASSWORD" ]; then
  echo "CREATE USER '$MYSQL_USER'@'%'  ;"         >> "$FIRST_TIME_SQL"
  echo "CREATE USER '$MYSQL_USER'@'localhost'  ;" >> "$FIRST_TIME_SQL"
fi

if [ "$MYSQL_USER" -a  "$MYSQL_DATABASE"  ]; then
  echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" >> "$FIRST_TIME_SQL"
  echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost' ;" >> "$FIRST_TIME_SQL"
fi

echo 'FLUSH PRIVILEGES ;' >> "$FIRST_TIME_SQL"
