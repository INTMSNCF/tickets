# INTM-SNFC Tickets

## Ticket 52

Build: ```$ docker-compose build```

Active containers: ```$ docker-compose up -d```

Into old version: ```$ docker-compose exec psql-old bash```

Into lastest version: ```$ docker-compose exec psql-lastest bash```

Active service: ```$ sudo service postgresql start```

Into postgres: ```$ su - postgres -c /usr/local/pgsql/bin/psql -d test```

Active modules: ```=# CREATE EXTENSION pgcrypto;```

Liste modules: ```=# \dx+```

## PostgreSQL - source code

https://github.com/INTMSNCF/postgres/tree/intm-t-52

## Reference

> L'erreur resemble beaucoup a : https://postgrespro.com/list/thread-id/1232267 mais la version utilisée est deja corrigée.

> Ticket sur la cominite : https://www.postgresql.org/message-id/16476-692ef7b84e5fb893%40postgresql.org

> Patch propose : https://www.postgresql.org/message-id/273426.1595533123%40sss.pgh.pa.us
