#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== sanity
--- http_config
    pinba_enable on;
--- config
    location /foo {
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- no_error_log: [error]
