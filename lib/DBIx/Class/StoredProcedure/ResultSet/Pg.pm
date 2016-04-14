package DBIx::Class::StoredProcedure::ResultSet::Pg;

use strict;
use warnings;

# ABSTRACT: specific trait for ResultSet objects in PostgreSQL
# VERSION

use DBIx::Class::StoredProcedure::Storage;
use Moo::Role;

sub storage {
    my ( $self, $values ) = @_;

    my $stored_procedure = $self->result_source->stored_procedure;
    my $params           = $self->result_source->parameters_hashref;

    my $sql = "";
    my @values;

    return DBIx::Class::StoredProcedure::Storage->new(
        storage => $self->result_source->storage,
        sql     => $sql,
        params  => \@values,
    );
}

1;
