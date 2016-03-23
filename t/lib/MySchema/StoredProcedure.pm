package MySchema::StoredProcedure;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('StoredProcedure');

1;
