#!/usr/bin/perl

use strict;
use warnings;

use lib "t/lib/";

use Test::Most;
use Test::Requires qw<Test::PostgreSQL>;

use Test::DBIx::Class {
    schema_class => 'MySchema',
    traits       => 'Testpostgresql',
};

plan tests => 1;

fixtures_ok sub {
    my $schema = shift;

    $schema->storage->dbh->do(<<'SQL');
CREATE FUNCTION foo( bar INTEGER, baz INTEGER DEFAULT 42 )
RETURNS TABLE(qux INTEGER) AS $$
BEGIN
    RETURN QUERY SELECT baz;
END
$$ LANGUAGE plpgsql;
SQL
};
