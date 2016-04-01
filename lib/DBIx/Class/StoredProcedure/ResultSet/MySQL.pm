package DBIx::Class::StoredProcedure::ResultSet::MySQL;

use strict;
use warnings;

# ABSTRACT: specific trait for ResultSet objects in MySQL
# VERSION

use DBIx::Class::StoredProcedure::Storage;
use Moo::Role;

sub storage {
    my ( $self, $values ) = @_;

    my $stored_procedure = $self->stored_procedure;
    my $params           = $self->parameters;

    while ( my ( $name => $param ) = each %$params ) {
        my $type = uc( $param->{type} // 'IN' );

        if ( $type eq 'IN' ) {
            next;
        }
        elsif ( $type eq 'INOUT' or $type eq 'OUT' ) {
            die "Output parameters not supported by DBD::mysql";
        }
        else {
            die "Invalid parameter type for parameter '$name'";
        }
    }

    my @params = keys %$params;
    my @values;

    {    # map hash %$values to @values list
        my %param_order = map { $params[$_] => $_ } 0 .. $#params;

        while ( my ( $key => $value ) = each %$values ) {
            my $index = $param_order{$key} // die "Unknown parameter: $key";
            $values[$index] = $value;
        }
    }

    # example case:
    # $values = { foo => 1, baz => 3}
    # @params = qw< foo bar baz>
    # --> 'baz' given, but 'bar' has no value!
    for ( @params[ 0 .. $#values ] ) {
        exists $values->{$_}
          or die "Elements missing while transforming"
          . " named into positional parameters!";
    }

    my $placeholders = join "," => ("?") x @values;
    my $sql = "CALL $stored_procedure($placeholders)";

    return DBIx::Class::StoredProcedure::Storage->new(
        storage => $self->result_source->storage,
        sql     => $sql,
        params  => \@values,
    );
}

1;
