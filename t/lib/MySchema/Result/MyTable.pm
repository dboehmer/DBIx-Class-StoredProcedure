package MySchema::Result::MyTable;

use strict;
use warnings;

use base 'MySchema::Result';

__PACKAGE__->table('my_table');

__PACKAGE__->add_columns(
    offset => {
        data_type   => 'integer',
        is_nullable => 1,
    },
);

__PACKAGE__->has_many(
    times => 'MySchema::Result::Time',
    { 'foreign.offset' => 'self.offset' },
);

1;
