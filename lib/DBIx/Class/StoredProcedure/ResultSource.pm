package DBIx::Class::StoredProcedure::ResultSource;

use strict;
use warnings;

use base 'DBIx::Class::ResultSource::Table';

use Tie::IxHash;

__PACKAGE__->mk_group_accessors( simple => qw<_parameters> );

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_);

    $self->{_parameters} ||= do { tie my %p, 'Tie::IxHash'; \%p };

    return $self;
}

sub add_parameter {
    my ( $self, $param, $info ) = @_;

    if ( $param =~ s/^\+// ) {
        my $p = $self->_parameters->{$param} ||= {};
        %$p = ( %$p, $info );
    }
    else {
        $self->_parameters->{$param} = $info;
    }
}

sub add_parameters {
    my $self = shift;

    while (@_) {
        $self->add_parameter( shift, shift );
    }
}

sub parameters_hashref { shift->_parameters }

sub stored_procedure { shift->name }

1;
