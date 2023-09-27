#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

no_shuffle();

run_tests();

__DATA__

=== tags: simple
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    location /foo {
        pinba_tag one "two";
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request tag: one = two/,
]

=== tags: single override
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    pinba_tag one "two";
    location /foo {
        pinba_tag one "three";
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request tag: one = three/,
]

=== tags: multiple override
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    pinba_tag one "two";
    pinba_tag two "three";
    location /foo {
        pinba_tag two "four";
        pinba_tag three "five";
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request tag: one = two/,
    qr/\[debug\] .* \[pinba\] request tag: two = four/,
    qr/\[debug\] .* \[pinba\] request tag: three = five/,
]
