package MySchema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_components('StoredProcedure::Schema');

__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSet' );

1;
