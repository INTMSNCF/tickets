#!/bin/bash

# For excecution: docker-compose exec psql-prod bash
# Befroe excecution:
# sudo -i
# service postgresql start
# chmod -R 777 /usr/lib/postgresql/9.4/lib
# chmod -R 777 /usr/share/postgresql/9.4/extension
# su - postgres
# bash /usr/intm/shared/run-test-prod.sh

clear

SCRIPT_PATH="$(dirname $0)"

InstallExtention(){
    psql -U postgres -c 'CREATE EXTENSION pgcrypto;'
    echo -e "\e[32m-- Extentions after install : \e[0m"
    psql -U postgres -c 'SELECT * FROM pg_extension;'
}

UninstallExtention(){
    psql -U postgres -c 'DROP EXTENSION IF EXISTS pgcrypto;'
    echo -e "\e[32m-- Extentions after uninstall : \e[0m"
    psql -U postgres -c 'SELECT * FROM pg_extension;'
}

runTest(){
    set +e
    echo -e "\e[32m-- Query test : test.sql : \e[0m"
    cat "$SCRIPT_PATH/test.sql"
    echo -e "\e[32m---- Result : \e[0m"
    psql -f "$SCRIPT_PATH/test.sql"
    echo -e "\e[32m-- Perl test  : pgcrypto_zip.pl \e[0m"
    cat "$SCRIPT_PATH/pgcrypto_zip.pl"
    echo -e "\e[32m---- Result : \e[0m"
    perl "$SCRIPT_PATH/pgcrypto_zip.pl"
    set -e
}

set -e

echo -e "-- PostgreSQL"
service postgresql status
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
psql -U postgres -c 'DROP EXTENSION IF EXISTS pgcrypto;'

echo -e "\e[32m-- PostgreSQL ok\e[0m"
echo -e "\e[32m-- Install extention pgcrypto 1.1 : \e[0m"
InstallExtention

echo -e "\e[32m-- Run test with pgcrypto 1.1 : \e[0m"
runTest

echo -e "\e[32m-- Uninstall extention pgcrypto 1.1 : \e[0m"
UninstallExtention

echo -e "\e[32m-- Install patch pgcrypto 1.1-intm-sncf : \e[0m"
cp -fv /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib/pgcrypto.so /usr/lib/postgresql/9.4/lib/
cp -fv /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto* /usr/share/postgresql/9.4/extension/

echo -e "\e[32m-- Install extention pgcrypto 1.1-intm-sncf : \e[0m"
InstallExtention

echo -e "\e[32m-- Run test with pgcrypto 1.1-intm-sncf : \e[0m"
runTest
