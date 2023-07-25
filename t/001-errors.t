#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== errors: pinba_server - no port
--- http_config
    pinba_server "example.tld";
--- config
--- must_die
--- error_log
[pinba] no port in pinba server "example.tld"

=== errors: pinba_server - unknown server
--- http_config
    pinba_server "example.tld:33333";
--- config
--- must_die
--- error_log
[pinba] getaddrinfo("example.tld:33333") failed

=== errors: pinba_ignore_codes - short code
--- http_config
    pinba_ignore_codes 33;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "33"

=== errors: pinba_ignore_codes - unknown code
--- http_config
    pinba_ignore_codes 666;
--- config
--- must_die
--- error_log
[pinba] invalid status code value "666"

=== errors: pinba_tag - variable in request tag name
--- config
    set $var "var value";
    location /foo {
        pinba_tag $var "not supported";
    }
--- must_die
--- error_log
[pinba] request tag name cannot be variable

=== errors: pinba_timer - negative value
--- config
    location /foo {
        pinba_timer -1.0 1 {
            bar "baz";
        }
    }
--- must_die
--- error_log
[pinba] timer value must be greater than zero

=== errors: pinba_timer - negative hit count
--- config
    location /foo {
        pinba_timer 1.0 -1 {
            bar "baz";
        }
    }
--- must_die
--- error_log
[pinba] timer hit count must be greater than zero

=== errors: pinba_timer - no timer tags
--- config
    location /foo {
        pinba_timer 1.0 1 {}
    }
--- must_die
--- error_log
[pinba] timer has to have at least one timer tag

=== errors: pinba_timer - variable in timer tag name
--- config
    set $var "var value";
    location /foo {
        pinba_timer 1.0 1 {
            $var "not supported";
        }
    }
--- must_die
--- error_log
[pinba] timer tag name cannot be variable
