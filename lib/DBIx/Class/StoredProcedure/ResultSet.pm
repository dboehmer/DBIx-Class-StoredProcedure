package DBIx::Class::StoredProcedure::ResultSet;

use strict;
use warnings;

# ABSTRACT: base class for ResultSet classes that model stored procedures
# VERSION

use base 'DBIx::Class::ResultSet';

use DBIx::Class::Storage::DBI::Cursor;
use Moo::Role;

__PACKAGE__->mk_group_ro_accessors( simple => qw<sqlt_type> );

sub new {
    my $class = shift;
    my ($result_source) = @_;

    my $self = $class->SUPER::new(@_);
    $self->{sqlt_type} = $result_source->storage->sqlt_type;
    my $role = __PACKAGE__ . "::" . $self->sqlt_type;
    Moo::Role->apply_roles_to_object( $self, $role );
    return $self;
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

        my $storage = $self->storage( \%params );
        $self->{cursor} = DBIx::Class::Storage::DBI::Cursor->new($storage);
    }

    return $self->{cursor};
}

1;
