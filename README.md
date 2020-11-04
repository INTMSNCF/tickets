# INTM-SNFC Tickets

## Ticket 52

Build: ```$ docker-compose build```

Into old version: ```$ docker-compose run psql-old bash```

Into lastest version: ```$ docker-compose run psql-lastest bash```

Active service: ```$ sudo service postgresql start```

Into postgres: ```$ sudo -u postgres psql```

## PostgreSQL - source code

https://github.com/INTMSNCF/postgres/tree/intm-t-52

## Reference

> L'erreur resemble beaucoup a : https://postgrespro.com/list/thread-id/1232267 mais la version utilisée est deja corrigée.

```sql
-- Signle query test
select pgp_sym_decrypt(pgp_sym_encrypt('DATA_FROM_FILE','password','debug=3D1'),'password','debug=3D1');
-- Signle query test width bytea
select pgp_sym_decrypt_bytea(pgp_sym_encrypt_bytea('DATA_FROM_FILE','password', 'compress-algo=1, cipher-algo=aes256'), 'password', 'compress-algo=1, cipher-algo=aes256');
-- Advanced TEST
select pgp_sym_decrypt_bytea(pgp_sym_encrypt_bytea(DATA_FROM_FILE, 'password', 'compress-algo=1, cipher-algo=aes256'), 'password', 'compress-algo=1, cipher-algo=aes256');
```
