# Ticket 52 test 01 bis 01

Implémentation de compilation du code correctif du bug 16476 sur une version PostgreSL 9.4.22 et des tests demandés par le client

## Script de test

<pre><font color="#4E9A06"><b>intm@intm-post</b></font>:<font color="#3465A4"><b>~/tickets/52</b></font>$ docker-compose exec psql-prod bash
intm@psql-prod:/usr/intm/postgres$ sudo -i
[sudo] password for intm:
root@psql-prod:~# service postgresql start
    * Starting PostgreSQL 9.4 database server                                                                                                                                                              [ OK ]
root@psql-prod:~# chmod -R 777 /usr/lib/postgresql/9.4/lib
root@psql-prod:~# chmod -R 777 /usr/share/postgresql/9.4/extension
root@psql-prod:~# su - postgres
postgres@psql-prod:~$ bash /usr/intm/shared/run-test-prod.sh
-- PostgreSQL
9.4/main (port 5432): online
ALTER ROLE
NOTICE:  extension &quot;pgcrypto&quot; does not exist, skipping
DROP EXTENSION
<font color="#4E9A06">-- PostgreSQL ok</font>
<font color="#4E9A06">-- Install extention pgcrypto 1.1 : </font>
CREATE EXTENSION
<font color="#4E9A06">-- Extentions after install : </font>
    extname  | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
----------+----------+--------------+----------------+------------+-----------+--------------
    plpgsql  |       10 |           11 | f              | 1.0        |           |
    pgcrypto |       10 |         2200 | t              | 1.1        |           |
(2 rows)

<font color="#4E9A06">-- Run test with pgcrypto 1.1 : </font>
<font color="#4E9A06">-- Query test : test.sql : </font>
\set DATA &apos;\&apos;/usr/intm/shared/CP04003072_PART2_SANS_ENTETE.zip\&apos;&apos;
-- Importer un fichier de données
create or replace function bytea_import(p_path text, p_result out bytea)
    language plpgsql as $$
    declare
        l_oid oid;
        r record;
    begin
        p_result := &apos;&apos;;
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
            &apos;password&apos;,
            &apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6&apos;
        ),
        &apos;password&apos;,
        &apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6&apos;
    ));
<font color="#4E9A06">---- Result : </font>
CREATE FUNCTION
    octet_length
--------------
        692427
(1 row)

<font color="#4E9A06">-- Perl test  : pgcrypto_zip.pl </font>
#!usr/bin/perl

use strict;
use warnings;
require DBI;
use DBD::Pg qw(:pg_types);
use Data::Dumper; $Data::Dumper::Useqq=1;

$|=1;

my $dbh=DBI-&gt;connect(&apos;dbi:Pg:host=localhost&apos;,&apos;postgres&apos;,&apos;postgres&apos;, {AutoCommit =&gt; 1, RaiseError=&gt;0, PrintError=&gt;1});

my $dec= $dbh-&gt;prepare(&quot;select pgp_sym_decrypt_bytea(pgp_sym_encrypt_bytea(?,?,&apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=1&apos;),?,&apos;debug=1&apos;);&quot;);
$dec-&gt;bind_param(1, &apos;&apos;, { pg_type =&gt; PG_BYTEA });

foreach my $ii (16360..16365) {
    my $i=$ii;
    my $password=join (&apos;&apos;,map chr(rand()*255+1), 0..rand(20));
    my $password2=join (&apos;&apos;,map chr(rand()*255+1), 0..rand(20));
    my $message=join (&apos;&apos;,map chr(rand()*256), 0..$i);
    $dec-&gt;execute($message,$password,$password);
    my ($message2)=$dec-&gt;fetchrow();
    die Dumper([$i,$password]) unless $message2 eq $message;
    warn &quot;$ii\t&quot;, time() ; #if $ii%1000 ==0;
};
<font color="#4E9A06">---- Result : </font>
16360	1605697327 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16361	1605697327 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16362	1605697327 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16363	1605697327 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16364	1605697327 at /usr/intm/shared/pgcrypto_zip.pl line 24.
NOTICE:  dbg: pgp_parse_pkt_hdr: not pkt hdr
DBD::Pg::st execute failed: ERROR:  Wrong key or corrupt data at /usr/intm/shared/pgcrypto_zip.pl line 21.
Use of uninitialized value $message2 in string eq at /usr/intm/shared/pgcrypto_zip.pl line 23.
$VAR1 = [
            16365,
            &quot;S*\313v\&quot;\6\340\341\376\225&quot;
        ];
<font color="#4E9A06">-- Uninstall extention pgcrypto 1.1 : </font>
DROP EXTENSION
<font color="#4E9A06">-- Extentions after uninstall : </font>
    extname | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
---------+----------+--------------+----------------+------------+-----------+--------------
    plpgsql |       10 |           11 | f              | 1.0        |           |
(1 row)

<font color="#4E9A06">-- Install patch pgcrypto 1.1-intm-sncf : </font>
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib/pgcrypto.so&apos; -&gt; &apos;/usr/lib/postgresql/9.4/lib/pgcrypto.so&apos;
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.0--1.1.sql&apos; -&gt; &apos;/usr/share/postgresql/9.4/extension/pgcrypto--1.0--1.1.sql&apos;
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.1-intm-sncf.sql&apos; -&gt; &apos;/usr/share/postgresql/9.4/extension/pgcrypto--1.1-intm-sncf.sql&apos;
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.1.sql&apos; -&gt; &apos;/usr/share/postgresql/9.4/extension/pgcrypto--1.1.sql&apos;
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--unpackaged--1.0.sql&apos; -&gt; &apos;/usr/share/postgresql/9.4/extension/pgcrypto--unpackaged--1.0.sql&apos;
&apos;/usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto.control&apos; -&gt; &apos;/usr/share/postgresql/9.4/extension/pgcrypto.control&apos;
<font color="#4E9A06">-- Install extention pgcrypto 1.1-intm-sncf : </font>
CREATE EXTENSION
<font color="#4E9A06">-- Extentions after install : </font>
    extname  | extowner | extnamespace | extrelocatable |  extversion   | extconfig | extcondition
----------+----------+--------------+----------------+---------------+-----------+--------------
    plpgsql  |       10 |           11 | f              | 1.0           |           |
    pgcrypto |       10 |         2200 | t              | 1.1-intm-sncf |           |
(2 rows)

<font color="#4E9A06">-- Run test with pgcrypto 1.1-intm-sncf : </font>
<font color="#4E9A06">-- Query test : test.sql : </font>
\set DATA &apos;\&apos;/usr/intm/shared/CP04003072_PART2_SANS_ENTETE.zip\&apos;&apos;
-- Importer un fichier de données
create or replace function bytea_import(p_path text, p_result out bytea)
    language plpgsql as $$
    declare
        l_oid oid;
        r record;
    begin
        p_result := &apos;&apos;;
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
            &apos;password&apos;,
            &apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6&apos;
        ),
        &apos;password&apos;,
        &apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=6&apos;
    ));
<font color="#4E9A06">---- Result : </font>
CREATE FUNCTION
    octet_length
--------------
        692427
(1 row)

<font color="#4E9A06">-- Perl test  : pgcrypto_zip.pl </font>
#!usr/bin/perl

use strict;
use warnings;
require DBI;
use DBD::Pg qw(:pg_types);
use Data::Dumper; $Data::Dumper::Useqq=1;

$|=1;

my $dbh=DBI-&gt;connect(&apos;dbi:Pg:host=localhost&apos;,&apos;postgres&apos;,&apos;postgres&apos;, {AutoCommit =&gt; 1, RaiseError=&gt;0, PrintError=&gt;1});

my $dec= $dbh-&gt;prepare(&quot;select pgp_sym_decrypt_bytea(pgp_sym_encrypt_bytea(?,?,&apos;debug=1, compress-algo=1, cipher-algo=aes256, compress-level=1&apos;),?,&apos;debug=1&apos;);&quot;);
$dec-&gt;bind_param(1, &apos;&apos;, { pg_type =&gt; PG_BYTEA });

foreach my $ii (16360..16365) {
    my $i=$ii;
    my $password=join (&apos;&apos;,map chr(rand()*255+1), 0..rand(20));
    my $password2=join (&apos;&apos;,map chr(rand()*255+1), 0..rand(20));
    my $message=join (&apos;&apos;,map chr(rand()*256), 0..$i);
    $dec-&gt;execute($message,$password,$password);
    my ($message2)=$dec-&gt;fetchrow();
    die Dumper([$i,$password]) unless $message2 eq $message;
    warn &quot;$ii\t&quot;, time() ; #if $ii%1000 ==0;
};
<font color="#4E9A06">---- Result : </font>
16360	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16361	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16362	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16363	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16364	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16365	1605697328 at /usr/intm/shared/pgcrypto_zip.pl line 24.
postgres@psql-prod:~$ exit
logout
root@psql-prod:~# exit
logout
intm@psql-prod:/usr/intm/postgres$ exit
exit
<font color="#4E9A06"><b>intm@intm-post</b></font>:<font color="#3465A4"><b>~/tickets/52</b></font>$
</pre>
### Description

Le fichier mesure 692427, après avoir effectué l'encodage et le décodage au niveau de compression 6, il ne marque aucune erreur et la taille est adéquate dans n'importe quelle version de pgcrypto

Exécution du script de test Perl fournie:

- [x] erreur dans la sixième interaction avec pgcrypto 1.1
- [x] success dans ses 6 interactions apres installe pgcrypto 1.1-intm-sncf
