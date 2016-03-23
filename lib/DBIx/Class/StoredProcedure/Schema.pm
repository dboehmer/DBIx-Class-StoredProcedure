package DBIx::Class::StoredProcedure::Schema;

use strict;
use warnings;

use base 'DBIx::Class';

use Module::Load;

sub load_namespaces {
    my ( $class, %args ) = @_;

    my $result_namespace;

    if ( ref $args{result_namespace} eq 'ARRAY' ) {
        $result_namespace = $args{result_namespace};
    }
    else {    # make result_namespace an array
        my $scalar = delete $args{result_namespace};
        $result_namespace = $args{result_namespace} = [];
        $scalar and push @$result_namespace, $scalar;
    }

    my $sp_namespace =
      delete $args{stored_procedure_namespace} || 'StoredProcedure';

    if ( ref $sp_namespace eq 'ARRAY' ) {
        push @$result_namespace, @$sp_namespace;
    }
    else {
        push @$result_namespace, $sp_namespace;
    }

    delete $args{default_stored_procedure_class};    # TODO handle this arg

    return $class->next::method(%args);
}

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
