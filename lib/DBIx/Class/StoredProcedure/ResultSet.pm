package DBIx::Class::StoredProcedure::ResultSet;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use DBIx::Class::Storage::DBI::Cursor;

sub new {
    my $class = shift;
    my ($result_source) = @_;

    my $sqlt_type = $result_source->storage->sqlt_type;
    $class->load_components("StoredProcedure::ResultSet::$sqlt_type");

    return $class->SUPER::new(@_);
}

sub stored_procedure { shift->result_source->name }

sub cursor {
    my $self = shift;

    if ( not $self->{cursor} ) {
        my $cols = $self->result_source->arguments;

        my %params;

        my $me    = $self->current_source_alias;
        my $where = $self->{_attrs}{where};
        for my $col ( keys %$cols ) {

            # TODO find solution to distinguish me.$col and $col
            if ( exists $where->{"$me.$col"} ) {
                $params{$col} = $where->{"$me.$col"};
            }
            elsif ( exists $where->{$col} ) {
                $params{$col} = $where->{$col};
            }
        }

        my $storage = $self->storage(\%params);
        $self->{cursor} = DBIx::Class::Storage::DBI::Cursor->new($storage);
    }

    return $self->{cursor};
}

1;
