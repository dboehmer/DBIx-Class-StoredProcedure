package DBIx::Class::StoredProcedure;

use strict;
use warnings;

# ABSTRACT: model stored procedures from your database in your DBIC schema
# VERSION

use base 'DBIx::Class';

# TODO better use a class like ResultSourceProxy?
sub add_parameter  { shift->result_source_instance->add_parameter(@_) }
sub add_parameters { shift->result_source_instance->add_parameters(@_) }

sub stored_procedure {
    my ( $class, $procedure ) = @_;

    # TODO find solution that works via load_components()

    {
        my $rs_class = $class->table_class;    # actually ResultSource class

        if ( !$rs_class or $rs_class eq 'DBIx::Class::ResultSource::Table' ) {
            $class->table_class( __PACKAGE__ . "::ResultSource" );
        }
    }

    $class->table($procedure);                 # necessary to satisfy DBIC

    # TODO find solution that works via load_components()

    {
        my $rs_class = $class->resultset_class;

        if ( !$rs_class or $rs_class eq 'DBIx::Class::ResultSet' ) {
            $class->resultset_class( __PACKAGE__ . "::ResultSet" );
        }
    }
}

=head1 ACKNOWLEDGEMENT

This software has been developed with support from L<STRATO|https://www.strato.com/>.
In German: Diese Software wurde mit Unterstützung von L<STRATO|https://www.strato.de/> entwickelt.

=cut

1;
