#!usr/bin/perl

use strict;
use warnings;
require DBI;
use DBD::Pg qw(:pg_types);
use Data::Dumper; $Data::Dumper::Useqq=1;

$|=1;

my $dbh=DBI->connect('dbi:Pg:host=localhost','postgres','postgres', {AutoCommit => 1, RaiseError=>0, PrintError=>1});

my $dec= $dbh->prepare("select pgp_sym_decrypt_bytea(pgp_sym_encrypt_bytea(?,?,'debug=1, compress-algo=1, cipher-algo=aes256, compress-level=1'),?,'debug=1');");
$dec->bind_param(1, '', { pg_type => PG_BYTEA });

foreach my $ii (16360..16365) {
  my $i=$ii;
  my $password=join ('',map chr(rand()*255+1), 0..rand(20));
  my $password2=join ('',map chr(rand()*255+1), 0..rand(20));
  my $message=join ('',map chr(rand()*256), 0..$i);
  $dec->execute($message,$password,$password);
  my ($message2)=$dec->fetchrow();
  die Dumper([$i,$password]) unless $message2 eq $message;
  warn "$ii\t", time() ; #if $ii%1000 ==0;
};
