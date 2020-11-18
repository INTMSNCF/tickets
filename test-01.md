# Ticket 52 test 01

Compilation du code correctif du bug 16476 et des tests demandés par le client

## Résultat du test

<pre><font color="#4E9A06"><b>intm@intm-post</b></font>:<font color="#3465A4"><b>~/tickets/52</b></font>$ docker-compose exec psql-old bash /usr/intm/postgres/compile.sh

[sudo] password for intm:
<font color="#4E9A06">-- Permission ok</font>
<font color="#4E9A06">-- Configuration ok</font>
<font color="#4E9A06">-- Build ok</font>
<font color="#4E9A06">-- Install ok</font>
-- Init db
Password:
The files belonging to this database system will be owned by user &quot;postgres&quot;.
This user must also own the server process.

The database cluster will be initialized with locale &quot;C&quot;.
The default database encoding has accordingly been set to &quot;SQL_ASCII&quot;.
The default text search configuration will be set to &quot;english&quot;.

Data page checksums are disabled.

fixing permissions on existing directory /usr/local/pgsql/data ... ok
creating subdirectories ... ok
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting dynamic shared memory implementation ... posix
creating configuration files ... ok
creating template1 database in /usr/local/pgsql/data/base/1 ... ok
initializing pg_authid ... ok
initializing dependencies ... ok
creating system views ... ok
loading system objects&apos; descriptions ... ok
creating collations ... ok
creating conversions ... ok
creating dictionaries ... ok
setting privileges on built-in objects ... ok
creating information schema ... ok
loading PL/pgSQL server-side language ... ok
vacuuming database template1 ... ok
copying template1 to template0 ... ok
copying template1 to postgres ... ok
syncing data to disk ... ok

WARNING: enabling &quot;trust&quot; authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
or
    /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start

<font color="#4E9A06">-- Init db ok</font>
-- Start PostgreSQL
Password:
<font color="#4E9A06">-- Start PostgreSQL ok</font>
<font color="#4E9A06">-- Base extentions : </font>
      Objects in extension &quot;plpgsql&quot;
            Object Description
-------------------------------------------
 function plpgsql_call_handler()
 function plpgsql_inline_handler(internal)
 function plpgsql_validator(oid)
 language plpgsql
(4 rows)

<font color="#4E9A06">-- Install pgcrypto extention : </font>
CREATE EXTENSION
<font color="#4E9A06">-- Extentions after install : </font>
            Objects in extension &quot;pgcrypto&quot;
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

      Objects in extension &quot;plpgsql&quot;
            Object Description
-------------------------------------------
 function plpgsql_call_handler()
 function plpgsql_inline_handler(internal)
 function plpgsql_validator(oid)
 language plpgsql
(4 rows)

 extname  | extowner | extnamespace | extrelocatable |  extversion   | extconfig | extcondition
----------+----------+--------------+----------------+---------------+-----------+--------------
 plpgsql  |       10 |           11 | f              | 1.0           |           |
 pgcrypto |       10 |         2200 | t              | 1.1-intm-sncf |           |
(2 rows)

<font color="#4E9A06">-- Backup patch pgcrypto 1.1-intm-sncf : </font>
/usr/local/pgsql/lib/pgcrypto.so -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/lib/pgcrypto.so
/usr/local/pgsql/share/extension/pgcrypto--1.0--1.1.sql -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.0--1.1.sql
/usr/local/pgsql/share/extension/pgcrypto--1.1-intm-sncf.sql -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.1-intm-sncf.sql
/usr/local/pgsql/share/extension/pgcrypto--1.1.sql -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--1.1.sql
/usr/local/pgsql/share/extension/pgcrypto--unpackaged--1.0.sql -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto--unpackaged--1.0.sql
/usr/local/pgsql/share/extension/pgcrypto.control -&gt; /usr/intm/shared/pgcrypto-9.4.21-INTM-SNCF/share/extension/pgcrypto.control

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
16360	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16361	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16362	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16363	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16364	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
16365	1605696218 at /usr/intm/shared/pgcrypto_zip.pl line 24.
<font color="#4E9A06"><b>intm@intm-post</b></font>:<font color="#3465A4"><b>~/tickets/52</b></font>$
</pre>

### Description

Le fichier mesure 692427, après avoir effectué l'encodage et le décodage au niveau de compression 6, il ne marque aucune erreur et la taille est adéquate.

Exécution du script de test Perl fournie avec success dans ses 6 interactions.
