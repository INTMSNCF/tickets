\set DATA '\'/usr/intm/shared/CP04003072_PART2_SANS_ENTETE.zip\''
-- Importer un fichier de données
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
-- Erreur et ticket 52
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
