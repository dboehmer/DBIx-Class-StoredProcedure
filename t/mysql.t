#!/usr/bin/perl

use strict;
use warnings;

use lib "t/lib/";

use MySchema;
use Test::Most;

eval "use DBICx::TemporaryMySQL; 1"
  or plan skip_all => "DBICx::TemporaryMySQL not found";

plan tests => 6;

ok my $schema = DBICx::TemporaryMySQL->new('MySchema');

ok $schema->storage->dbh->do(<<SQL);
    CREATE PROCEDURE simple_procedure (
        IN  id      INT,
        IN  name    VARCHAR(255)
    ) BEGIN
        SELECT id, name;
    END
SQL

ok $schema->storage->dbh->do("CALL simple_procedure(42, 'foo')");

ok my $res = $schema->stored_procedure("SimpleProcedure")
  ->execute( { id => 42, name => "foo" } )->next;

subtest results => sub {
    is $res->id   => 42;
    is $res->name => "foo";
};

throws_ok sub {
    $schema->execute_stored_procedure( ProcedureWithOutputParam => {} )->next;
  } => qr/DBD::mysql/,
  "Can't use OUT parameters because of DBD::mysql";
