#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== basic: use default values
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    location /foo {
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* http pinba handler/,
    qr/\[debug\] .* pinba request hostname: .*/,
    qr/\[debug\] .* pinba request script_name: \/foo/,
    qr/\[debug\] .* pinba request schema: http/,
]

=== basic: use pinba variables
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    set $pinba_hostname 'some.hostname';
    set $pinba_request_uri '/some_request_uri';
    set $pinba_request_schema 'some_schema';
    location /foo {
        add_header X-Pinba-Hostname $pinba_hostname;
        add_header X-Pinba-Request-Uri $pinba_request_uri;
        add_header X-Pinba-Request-Schema $pinba_request_schema;
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- response_headers
    X-Pinba-Hostname: some.hostname
    X-Pinba-Request-Uri: /some_request_uri
    X-Pinba-Request-Schema: some_schema
--- error_log eval
[
    qr/\[debug\] .* http pinba handler/,
    qr/\[debug\] .* pinba request hostname: some.hostname/,
    qr/\[debug\] .* pinba request script_name: \/some_request_uri/,
    qr/\[debug\] .* pinba request schema: some_schema/,
]

