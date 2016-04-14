#!/usr/bin/perl

use strict;
use warnings;

use lib "t/lib/";

use MySchema;
use Test::Most;
use Test::Requires qw<Test::mysqld>;

use Test::DBIx::Class {
    schema_class => 'MySchema',
    traits       => 'Testmysqld',
};

plan tests => 5;

fixtures_ok sub {
    my $schema = shift;

    $schema->storage->dbh->do(<<SQL);
CREATE PROCEDURE simple_procedure (
    IN  id      INT,
    IN  name    VARCHAR(255)
) BEGIN
    SELECT id, name;
END
SQL
};

ok Schema->storage->dbh->do("CALL simple_procedure(42, 'foo')");

ok my $res = Schema->stored_procedure("SimpleProcedure")
  ->execute( { id => 42, name => "foo" } )->next;

subtest results => sub {
    is $res->id   => 42;
    is $res->name => "foo";
};

throws_ok sub {
    Schema->execute_stored_procedure( ProcedureWithOutputParam => {} )->next;
  } => qr/DBD::mysql/,
  "Can't use OUT parameters because of DBD::mysql";
