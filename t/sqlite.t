#!/usr/bin/env perl

use strict;
use warnings;

use lib "t/lib/";

use Test::Most;
use Test::DBIx::Class {
    schema_class => 'MySchema',
    traits       => 'SQLite',
};

plan tests => 14;

fixtures_ok sub {
    my $schema = shift;

    $schema->storage->dbh->sqlite_create_function(
        'TIME', -1,
        sub {
            my ( $offset, $offset_min ) = @_;

            for ( $offset, $offset_min ) {
                no warnings 'numeric';
                $_ //= 0;    # default
                $_ += 0;     # numify
            }

            return time + $offset + 60 * $offset_min;
        }
    );
};

is Schema->storage->dbh->selectrow_arrayref("SELECT TIME()")->[0] => time,
  "SQL function TIME() returns time";

is Schema->storage->dbh->selectrow_arrayref("SELECT TIME(42)")->[0] =>
  ( time + 42 ),
  "SQL function TIME() accepts offset";

is Schema->storage->dbh->selectrow_arrayref("SELECT TIME('foo')")->[0] => time,
  "SQL function TIME() treats strings as 0";

ok my $rs = Schema->stored_procedure('Time'), '$schema->stored_procedure';
isa_ok $rs                => 'DBIx::Class::StoredProcedure::ResultSet';
isa_ok $rs->result_source => 'DBIx::Class::StoredProcedure::ResultSource';
ok $rs = $rs->search( { offset => 42 } ), '$resultset->search';
ok my $row = $rs->next, '$resultset->single';
can_ok $row => 'time';
is $row->time => ( time + 42 ), "\$row->time";

sub t { Schema->execute_stored_procedure( Time => {@_} )->next->time }

is t( offset => 42 ) => ( time + 42 ),
  "\$schema->execute_stored_procedure";

subtest "parameter order" => sub {
    is t( offset => 30, offset_min => 1 ) => time + 90,
      "offset,offset_min";
    is t( offset_min => 1, offset => 30 ) => time + 90,
      "offset_min,offset";

    dies_ok { t( offset_min => 42 ) } "2nd param only dies";
};

subtest relationships => sub {
    ok my $table = Schema->resultset('MyTable')->new( { offset => 42 } );

    ok my $rel_rs = $table->times;

    is $rel_rs->next->time => time + 42;
};
