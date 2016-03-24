#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most tests => 4;

bail_on_fail;

use_ok 'DBIx::Class::StoredProcedure';
use_ok 'MySchema';
use_ok 'MySchema::Result::MyTable';
use_ok 'MySchema::Result::Time';
