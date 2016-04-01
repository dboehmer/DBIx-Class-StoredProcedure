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

sub execute          { shift->search(@_) }
sub parameters       { shift->result_source->parameters }
sub stored_procedure { shift->result_source->name }

sub cursor {
    my $self = shift;

    if ( not $self->{cursor} ) {
        my $params = $self->result_source->parameters;

        my %values;

        my $me    = $self->current_source_alias;
        my $where = $self->{_attrs}{where};
        for my $param ( keys %$params ) {

            # TODO find solution to distinguish me.$param and $param
            if ( exists $where->{"$me.$param"} ) {
                $values{$param} = $where->{"$me.$param"};
            }
            elsif ( exists $where->{$param} ) {
                $values{$param} = $where->{$param};
            }
        }

        my $storage = $self->storage( \%values );
        $self->{cursor} = DBIx::Class::Storage::DBI::Cursor->new($storage);
    }

    return $self->{cursor};
}

1;
