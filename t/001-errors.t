#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: pinba_server - no port
--- http_config
    pinba_server "example.tld";
--- config
--- must_die
--- error_log
[pinba] no port in pinba server "example.tld"

=== TEST 2: pinba_server - unknown server
--- http_config
    pinba_server "example.tld:33333";
--- config
--- must_die
--- error_log
[pinba] getaddrinfo("example.tld:33333") failed

=== TEST 3: pinba_ignore_codes - short code
--- http_config
    pinba_ignore_codes 33;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "33"

=== TEST 4: pinba_ignore_codes - unknown code
--- http_config
    pinba_ignore_codes 666;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "666"

=== TEST 5: pinba_timer - negative value
--- config
    location /foo {
        pinba_timer -1.0 1 {
            bar "baz";
        }
    }
--- must_die
--- error_log
[pinba] timer value must be greater than zero

=== TEST 6: pinba_timer - negative hit count
--- config
    location /foo {
        pinba_timer 1.0 -1 {
            bar "baz";
        }
    }
--- must_die
--- error_log
[pinba] timer hit count must be greater than zero
