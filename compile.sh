#!/bin/bash

clear

set -e

sudo chown -R intm:intm /usr/intm/
sudo chown -R postgres:postgres /usr/local/pgsql/data
echo -e "\e[32m-- Permission ok\e[0m"
./configure
echo -e "\e[32m-- Configuration ok\e[0m"
make world
echo -e "\e[32m-- Build ok\e[0m"
sudo make install-world
echo -e "\e[32m-- Install ok\e[0m"
echo -e "-- Init db"
su - postgres -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data'
sleep 5
echo -e "\e[32m-- Init db ok\e[0m"
echo -e "-- Start PostgreSQL"
su - postgres -c '/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &'
sleep 15
echo -e "\e[32m-- Start PostgreSQL ok\e[0m"
echo -e "\e[32m-- Base extentions : \e[0m"
/usr/local/pgsql/bin/psql -U postgres -c '\dx+'
echo -e "\e[32m-- Install pgcrypto extention : \e[0m"
/usr/local/pgsql/bin/psql -U postgres -c 'CREATE EXTENSION pgcrypto;'
echo -e "\e[32m-- Extentions after install : \e[0m"
/usr/local/pgsql/bin/psql -U postgres -c '\dx+'
/usr/local/pgsql/bin/psql -U postgres -c 'SELECT * FROM pg_extension;'

echo -e "\e[32m-- Backup patch pgcrypto 1.1-intm-sncf : \e[0m"
cp -fv /usr/local/pgsql/lib/pgcrypto.so /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib/
cp -fv /usr/local/pgsql/share/extension/pgcrypto* /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/

bash /usr/intm/shared/run-test.sh
