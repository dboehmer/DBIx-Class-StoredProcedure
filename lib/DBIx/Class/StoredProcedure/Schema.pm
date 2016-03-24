package DBIx::Class::StoredProcedure::Schema;

use strict;
use warnings;

use base 'DBIx::Class';

sub execute_stored_procedure {
    my $self             = shift;
    my $stored_procedure = shift;

    $self->stored_procedure($stored_procedure)->search(@_);
}

sub stored_procedure {
    my ( $self, $stored_procedure ) = @_;

    return $self->resultset($stored_procedure);
}

1;
