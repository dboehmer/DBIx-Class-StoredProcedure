package DBIx::Class::StoredProcedure::ResultSet::SQLite;

use strict;
use warnings;

# ABSTRACT: specific trait for ResultSet objects in SQLite
# VERSION

use DBIx::Class::StoredProcedure::Storage;
use Moo::Role;

sub storage {
    my ( $self, $params ) = @_;

    my $stored_procedure = $self->stored_procedure;

    my $sql = "SELECT $stored_procedure("
      . join( ", ", map { "?" } keys %$params ) . ")";

    return DBIx::Class::StoredProcedure::Storage->new(
        storage => $self->result_source->storage,
        sql     => $sql,
        params  => [ values %$params ],
    );
}

1;
