package MySchema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_components('StoredProcedure::Schema');

__PACKAGE__->load_namespaces(
    result_namespace               => 'Result',
    resultset_namespace            => 'ResultSet',
    default_resultset_class        => 'ResultSet',
    stored_procedure_namespace     => 'StoredProcedure',
    default_stored_procedure_class => 'StoredProcedure',
);

1;
