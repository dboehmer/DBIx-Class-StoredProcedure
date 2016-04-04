package MySchema::Result::ProcedureWithOutputParam;

use strict;
use warnings;

use base 'MySchema::StoredProcedure';

__PACKAGE__->stored_procedure('procedure_w_out_param');

__PACKAGE__->add_parameters(
    id   => { is_nullable => 0, data_type => 'int' },
    name => { is_nullable => 0, data_type => 'varchar', size => 255 },
    counter => { type => 'OUT' },
);

__PACKAGE__->add_columns(
    id   => { is_nullable => 1, data_type => 'integer', },
    name => { is_nullable => 1, data_type => 'varchar', size => 255, },
);

1;
