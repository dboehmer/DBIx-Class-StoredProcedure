#!/usr/bin/env perl

use MySchema;
use Test::More;

eval "use DBD::SQLite; 1"
  or plan skip_all => "DBD::SQLite needed for this test";

plan tests => 4;

my $schema = MySchema->connect(
    "DBI:SQLite::memory:",
    undef, undef,
    {
        on_connect_do => sub {
            my $storage = shift;

            $storage->dbh->sqlite_create_function(
                'TIME', -1,
                sub {
                    my ($offset) = @_;

                    $offset //= 0;    # default
                    $offset += 0;     # numify

                    return time + $offset;
                }
            );
        },
    }
);

ok $schema, "MySchema->connect";

is $schema->storage->dbh->selectall_arrayref("SELECT TIME()")->[0][0] => time,
  "SQL function TIME() returns time";

is $schema->storage->dbh->selectall_arrayref("SELECT TIME(42)")->[0][0] =>
  ( time + 42 ),
  "SQL function TIME() accepts offset";

is $schema->storage->dbh->selectall_arrayref("SELECT TIME('foo')")->[0][0] =>
  time,
  "SQL function TIME() treats strings as 0";
