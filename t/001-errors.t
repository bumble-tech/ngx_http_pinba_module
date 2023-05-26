#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: pinba_ignore_codes - short code
--- http_config
    pinba_ignore_codes 33;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "33"

=== TEST 2: pinba_ignore_codes - unknown code
--- http_config
    pinba_ignore_codes 666;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "666"
