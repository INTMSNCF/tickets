# INTM-SNFC Tickets

## Ticket 52

Wrong Key or Corrupt Data avec pgp_sym_decrypt_bytea
### PostgreSQL - source code

https://github.com/INTMSNCF/postgres/tree/intm-t-52

[Binaires générés](https://github.com/INTMSNCF/tickets/releases/tag/52.20201118)

### Annoter

> L'erreur resemble beaucoup a : https://postgrespro.com/list/thread-id/1232267 mais la version utilisée est deja corrigée.

> Ticket communautaire : https://www.postgresql.org/message-id/16476-692ef7b84e5fb893%40postgresql.org

> Proposition de test : https://www.postgresql.org/message-id/CAMkU%3D1wJQyYj14SXTwp0msnk%3DShA0zizYeOB_biWf5F45JiWEQ%40mail.gmail.com

> Patch proposé : https://www.postgresql.org/message-id/273426.1595533123%40sss.pgh.pa.us

### Tests

[Test 01](https://github.com/INTMSNCF/tickets/blob/52/test-01.md) : Test avec la version de correctif référencée

[Test 01 - Bis](https://github.com/INTMSNCF/tickets/blob/52/test-01-bis-01.md) : Test avec des binaires de patch référencés

### Reference

Build: ```$ docker-compose build```

Active containers: ```$ docker-compose up -d```

Into old version: ```$ docker-compose exec psql-old bash```

Into production version: ```$ docker-compose exec psql-prod bash```

Into lastest version: ```$ docker-compose exec psql-lastest bash```

Liste modules: ```=# \dx+```
