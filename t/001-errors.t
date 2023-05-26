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

=== TEST 3: pinba_timer - negative value
--- config
    location /foo {
        pinba_timer -1.0 1 {
            bar "baz";
        }
        return 418;
    }
--- must_die
--- error_log
[pinba] timer value must be greater than zero

=== TEST 4: pinba_timer - negative hit count
--- config
    location /foo {
        pinba_timer 1.0 -1 {
            bar "baz";
        }
        return 418;
    }
--- must_die
--- error_log
[pinba] timer hit count must be greater than zero
