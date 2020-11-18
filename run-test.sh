#!/bin/bash

# For excecution: docker-compose exec psql-old bash /usr/intm/postgres/compile.sh
# Befroe excecution:
# bash /usr/intm/postgres/compile.sh

clear

SCRIPT_PATH="$(dirname $0)"

set -e

echo -e "\e[32m-- Query test : test.sql : \e[0m"
cat "$SCRIPT_PATH/test.sql"
echo -e "\e[32m---- Result : \e[0m"
/usr/local/pgsql/bin/psql -U postgres -f "$SCRIPT_PATH/test.sql"
echo -e "\e[32m-- Perl test  : pgcrypto_zip.pl \e[0m"
cat "$SCRIPT_PATH/pgcrypto_zip.pl"
echo -e "\e[32m---- Result : \e[0m"
perl "$SCRIPT_PATH/pgcrypto_zip.pl"
