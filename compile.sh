#!/bin/bash
set -e

make world
sudo make install-world
mkdir -p /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib
mkdir -p /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension
cp /usr/local/pgsql/lib/pgcrypto.so /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib/
cp /usr/local/pgsql/share/extension/pgcrypto* /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/
# For testt
# su - postgres -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data'
# su - postgres -c '/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &'
# su - postgres -c '/usr/local/pgsql/bin/createdb test'
# su - postgres -c '/usr/local/pgsql/bin/psql -d test'
