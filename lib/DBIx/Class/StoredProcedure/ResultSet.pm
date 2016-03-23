package DBIx::Class::StoredProcedure::ResultSet;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use DBIx::Class::Storage::DBI::Cursor;
use DBIx::Class::StoredProcedure::Storage;
use Module::Load;

sub cursor {
    my $self = shift;

    if ( not $self->{cursor} ) {
        my $stored_procedure = $self->result_source->name;
        my $cols             = $self->result_source->arguments;

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

        my $sql = "SELECT $stored_procedure("
          . join( ", ", map { "?" } keys %params ) . ")";

        my $storage = DBIx::Class::StoredProcedure::Storage->new(
            storage => $self->result_source->storage,
            sql     => $sql,
            params  => [ values %params ],
        );

        $self->{cursor} = DBIx::Class::Storage::DBI::Cursor->new($storage);
    }

    if ( not $self->{cursor} ) {
        my $sqlt_type = $self->result_source->storage->sqlt_type;
        my $cursor_class =
          'DBIx::Class::StoredProcedure::Cursor::' . $sqlt_type;
        load $cursor_class;    # TODO do beforehand?
        $self->{cursor} = $cursor_class->new($self);
    }

    return $self->{cursor};
}

1;
