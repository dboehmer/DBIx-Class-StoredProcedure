package MySchema::Result::Time;

use strict;
use warnings;

use base 'MySchema::StoredProcedure';

__PACKAGE__->procedure("time");

__PACKAGE__->add_arguments(
    offset => { data_type => "int", is_nullable => 1 },
);

__PACKAGE__->add_columns(
    time => { data_type => "int", is_nullable => 0 },
);

1;
