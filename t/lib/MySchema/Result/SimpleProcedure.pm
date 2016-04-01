package MySchema::Result::SimpleProcedure;

use strict;
use warnings;

use base 'MySchema::StoredProcedure';

__PACKAGE__->procedure('simple_procedure');

__PACKAGE__->add_parameters(
    id   => { is_nullable => 0, data_type => 'int' },
    name => { is_nullable => 0, data_type => 'varchar', size => 255 },
);

__PACKAGE__->add_columns(
    id   => { is_nullable => 1, data_type => 'integer', },
    name => { is_nullable => 1, data_type => 'varchar', size => 255, },
);

1;
