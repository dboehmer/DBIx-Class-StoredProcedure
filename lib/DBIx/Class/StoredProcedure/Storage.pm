package DBIx::Class::StoredProcedure::Storage;

use strict;
use warnings;

use Moo;

has storage => (
    is       => 'ro',
    required => 1,
    handles  => ['throw_exception'],
);

has sql => (
    is       => 'ro',
    required => 1,
);

has params => (
    is       => 'ro',
    required => 1,
);

sub _select {
    my $self = shift;

    return $self->storage->dbh_do(
        sub {
            my ( $storage, $dbh ) = @_;

            if ( $ENV{DBIC_TRACE} ) {
                my $dump = $self->sql;
                if ( @{ $self->params } ) {
                    $dump .= ": ";
                    $dump .= join ", ",
                      map { defined() ? "'$_'" : "NULL" } @{ $self->params };
                }
                warn "$dump\n";
            }

            my $sth = $dbh->prepare( $self->sql );
            my $rv  = $sth->execute( @{ $self->params } );

            return ( $rv, $sth );    # TODO correct?
        }
    );
}

1;
