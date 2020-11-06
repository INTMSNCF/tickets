# Ticket 52 text 01

Compilation du code correctif du bug 16476 et des tests demandés par le client

## Script de test

```sql
\set DATA '\'/usr/intm/shared/CP04003072_PART2_SANS_ENTETE.zip\''
create or replace function bytea_import(p_path text, p_result out bytea)
    language plpgsql as $$
    declare
        l_oid oid;
        r record;
    begin
        p_result := '';
        select lo_import(p_path) into l_oid;
        for r in (
            select data
            from pg_largeobject
            where loid = l_oid
            order by pageno
        ) loop
            p_result = p_result || r.data;
        end loop;
        perform lo_unlink(l_oid);
    end;$$;
select
    octet_length(pgp_sym_decrypt_bytea(
        pgp_sym_encrypt_bytea(
            bytea_import(:DATA),
            'password',
            'debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6'
        ),
        'password',
        'debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6'
    ));
```

## Résultat du test

```shell
$ docker-compose exec psql-old bash
$ su - postgres -c '/usr/local/pgsql/bin/psql -d test'
Password:
psql (9.4.21)
Type "help" for help.

test=# \dx+
            Objects in extension "pgcrypto"
                  Object Description
-------------------------------------------------------
 function armor(bytea)
 function crypt(text,text)
 function dearmor(text)
 function decrypt(bytea,bytea,text)
 function decrypt_iv(bytea,bytea,bytea,text)
 function digest(bytea,text)
 function digest(text,text)
 function encrypt(bytea,bytea,text)
 function encrypt_iv(bytea,bytea,bytea,text)
 function gen_random_bytes(integer)
 function gen_random_uuid()
 function gen_salt(text)
 function gen_salt(text,integer)
 function hmac(bytea,bytea,text)
 function hmac(text,text,text)
 function pgp_key_id(bytea)
 function pgp_pub_decrypt(bytea,bytea)
 function pgp_pub_decrypt(bytea,bytea,text)
 function pgp_pub_decrypt(bytea,bytea,text,text)
 function pgp_pub_decrypt_bytea(bytea,bytea)
 function pgp_pub_decrypt_bytea(bytea,bytea,text)
 function pgp_pub_decrypt_bytea(bytea,bytea,text,text)
 function pgp_pub_encrypt(text,bytea)
 function pgp_pub_encrypt(text,bytea,text)
 function pgp_pub_encrypt_bytea(bytea,bytea)
 function pgp_pub_encrypt_bytea(bytea,bytea,text)
 function pgp_sym_decrypt(bytea,text)
 function pgp_sym_decrypt(bytea,text,text)
 function pgp_sym_decrypt_bytea(bytea,text)
 function pgp_sym_decrypt_bytea(bytea,text,text)
 function pgp_sym_encrypt(text,text)
 function pgp_sym_encrypt(text,text,text)
 function pgp_sym_encrypt_bytea(bytea,text)
 function pgp_sym_encrypt_bytea(bytea,text,text)
(34 rows)

      Objects in extension "plpgsql"
            Object Description
-------------------------------------------
 function plpgsql_call_handler()
 function plpgsql_inline_handler(internal)
 function plpgsql_validator(oid)
 language plpgsql
(4 rows)

test=# SELECT * FROM pg_extension
test-# ;
 extname  | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
----------+----------+--------------+----------------+------------+-----------+--------------
 plpgsql  |       10 |           11 | f              | 1.0        |           |
 pgcrypto |       10 |         2200 | t              | 1.1        |           |
(2 rows)

test=# \set DATA '\'/usr/intm/shared/CP04003072_PART2_SANS_ENTETE.zip\''
test=# create or replace function bytea_import(p_path text, p_result out bytea)
test-#     language plpgsql as $$
test$#     declare
test$#         l_oid oid;
test$#         r record;
test$#     begin
test$#         p_result := '';
test$#         select lo_import(p_path) into l_oid;
test$#         for r in (
test$#             select data
test$#             from pg_largeobject
test$#             where loid = l_oid
test$#             order by pageno
test$#         ) loop
test$#             p_result = p_result || r.data;
test$#         end loop;
test$#         perform lo_unlink(l_oid);
test$#     end;$$;
CREATE FUNCTION
test=# select
test-#     octet_length(pgp_sym_decrypt_bytea(
test(#         pgp_sym_encrypt_bytea(
test(#             bytea_import(:DATA),
test(#             'password',
test(#             'debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6'
test(#         ),
test(#         'password',
test(#         'debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6'
test(#     ));
 octet_length
--------------
       692427
(1 row)

test=# \q
$ exit
exit
$ ll CP04003072_PART2_SANS_ENTETE.zip
-rw-r--r-- 1 intm intm 692427 nov.   6 15:05 CP04003072_PART2_SANS_ENTETE.zip
```

### Description

