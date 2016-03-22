package DBIx::Class::StoredProcedure;

use strict;
use warnings;

use base 'DBIx::Class::Core';

sub add_argument { shift->add_arguments(@_) }

sub add_arguments {
    my ( $class, @args ) = @_;

    for my $arg (@args) { }
}

sub procedure {
    my ( $class, $procedure ) = @_;

    $class->table($procedure);    # necessary to satisfy DBIC
}

1;
