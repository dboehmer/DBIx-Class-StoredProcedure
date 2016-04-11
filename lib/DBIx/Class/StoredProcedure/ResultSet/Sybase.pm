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

    my %out_params;
    my @values;

    while ( my ( $name => $param ) = each %$params ) {
        my $type = uc( $param->{type} // 'IN' );

        my ( $variable, $value );

        if ( $type eq 'IN' or $type eq 'INOUT' ) {
            if ( exists $values->{$name} ) {
                $value = \$values->{$name};
            }
        }

        if ( $type eq 'INOUT' or $type eq 'OUT' ) {
            $variable = $name;
        }
        else {
            die "Invalid parameter type for parameter '$name'";
        }
    }

    my $sql = "";

    if (%out_params) {
        $sql .= "DECLARE ";

        while ( my ( $name => $param ) = each %$params ) {
            my $type = uc( $param->{type} // 'IN' );

            if ( $type eq 'INOUT' ) {
                $sql .= "\@$name";
                if ( exists $values->{$name} ) {
                    my $value = $values->{name};
                    if ( not defined $value ) {
                        $value = "undef";
                    }
                    elsif ( not looks_like_number($value) ) {
                        $value = qq('$value');
                    }

                    $sql .= " = $value";
                }
            }
        }
    }
    $sql .= "EXECUTE $stored_procedure";

    return DBIx::Class::StoredProcedure::Storage->new(
        storage => $self->result_source->storage,
        sql     => $sql,
        params  => \@values,
    );
}

1;
