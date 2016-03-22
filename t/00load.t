#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most tests => 3;

bail_on_fail;

use_ok 'DBIx::Class::StoredProcedure';
use_ok 'MySchema';
use_ok 'MySchema::StoredProcedure::Time';
