package DBIx::Class::StoredProcedure::Schema;

use strict;
use warnings;

# ABSTRACT: Component for Schema classes for easier access to stored procedures
# VERSION

use base 'DBIx::Class';

sub execute_stored_procedure {
    my $self             = shift;
    my $stored_procedure = shift;

    $self->stored_procedure($stored_procedure)->execute(@_);
}

sub stored_procedure {
    my ( $self, $stored_procedure ) = @_;

    return $self->resultset($stored_procedure);
}

1;
