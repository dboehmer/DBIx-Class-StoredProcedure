#!/usr/bin/env perl

use MySchema;
use Test::More;

eval "use DBD::SQLite; 1"
  or plan skip_all => "DBD::SQLite needed for this test";

plan tests => 2;

my $schema = MySchema->connect(
    "DBI:SQLite::memory:",
    undef, undef,
    {
        on_connect_do => sub {
            my $storage = shift;

            $storage->dbh->sqlite_create_function( 'TIME', 0, sub { time } );
        },
    }
);

ok $schema, "MySchema->connect";

is_deeply $schema->storage->dbh->selectall_arrayref("SELECT TIME()") =>
  [ [time] ],
  "SQL function TIME() returns time";
