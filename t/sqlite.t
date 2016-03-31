#!/usr/bin/env perl

use strict;
use warnings;

use lib "t/lib/";

use MySchema;
use Test::More;

eval "use DBD::SQLite; 1"
  or plan skip_all => "DBD::SQLite needed for this test";

plan tests => 12;

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

is $schema->storage->dbh->selectrow_arrayref("SELECT TIME()")->[0] => time,
  "SQL function TIME() returns time";

is $schema->storage->dbh->selectrow_arrayref("SELECT TIME(42)")->[0] =>
  ( time + 42 ),
  "SQL function TIME() accepts offset";

is $schema->storage->dbh->selectrow_arrayref("SELECT TIME('foo')")->[0] => time,
  "SQL function TIME() treats strings as 0";

ok my $rs = $schema->stored_procedure('Time'), '$schema->stored_procedure';
isa_ok $rs => 'DBIx::Class::StoredProcedure::ResultSet';
ok $rs = $rs->search( { offset => 42 } ), '$resultset->search';
ok my $row = $rs->next, '$resultset->single';
can_ok $row => 'time';
is $row->time => ( time + 42 ), '$row->time';

is $schema->execute_stored_procedure( Time => { offset => 42 } )->next->time =>
  ( time + 42 ),
  '$schema->execute_stored_procedure';

subtest relationships => sub {
    ok my $table = $schema->resultset('MyTable')->new( { offset => 42 } );

    ok my $rel_rs = $table->times;

    is $rel_rs->next->time => time + 42;
};
