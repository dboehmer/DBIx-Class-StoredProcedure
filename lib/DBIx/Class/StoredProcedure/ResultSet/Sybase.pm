package DBIx::Class::StoredProcedure::ResultSet::Sybase;

use strict;
use warnings;

# ABSTRACT: specific trait for ResultSet objects in Sybase
# VERSION

use DBIx::Class::StoredProcedure::Storage;
use Moo::Role;

sub storage {
    my ( $self, $values ) = @_;

    my $stored_procedure = $self->result_source->stored_procedure;
    my $params           = $self->result_source->parameters_hashref;

    while ( my ( $name => $param ) = each %$params ) {
        my $type = uc( $param->{type} // 'IN' );

        if ( $type eq 'IN' ) {
            next;
        }
        elsif ( $type eq 'INOUT' or $type eq 'OUT' ) {
            # TODO
        }
        else {
            die "Invalid parameter type for parameter '$name'";
        }
    }

    # TODO generate $sql

    return DBIx::Class::StoredProcedure::Storage->new(
        storage => $self->result_source->storage,
        sql     => $sql,
        params  => \@values,
    );
}

1;
