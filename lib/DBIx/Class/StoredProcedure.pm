package DBIx::Class::StoredProcedure;

use strict;
use warnings;

# ABSTRACT: model stored procedures from your database in your DBIC schema
# VERSION

use base 'DBIx::Class';

sub add_argument {
    my ( $class, $name, $spec ) = @_;

    $class->result_source_instance->arguments->{$name} = $spec;
}

sub add_arguments {
    my $class = shift;

    while (@_) {
        $class->add_argument( shift, shift );
    }
}

sub procedure {
    my ( $class, $procedure ) = @_;

    $class->table($procedure);    # necessary to satisfy DBIC

    # TODO find solution that works via load_components()

    $class->result_source_instance->mk_classdata( arguments => {} );

    {
        my $rs_class = $class->resultset_class;

        if ( !$rs_class or $rs_class eq 'DBIx::Class::ResultSet' ) {
            $class->resultset_class( __PACKAGE__ . "::ResultSet" );
        }
    }
}

1;
