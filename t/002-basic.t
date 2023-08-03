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
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request hostname: .*/,
    qr/\[debug\] .* \[pinba\] request script_name: \/foo/,
    qr/\[debug\] .* \[pinba\] request schema: http/,
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
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request hostname: some.hostname/,
    qr/\[debug\] .* \[pinba\] request script_name: \/some_request_uri/,
    qr/\[debug\] .* \[pinba\] request schema: some_schema/,
]

=== basic: pinba_server override
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
    pinba_resolve_freq 0;
--- config
    location /foo {
        pinba_server "127.0.0.1:44444";
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] server 127.0.0.1:44444 re-resolve after 0 sec/,
]


=== basic: pinba_resolve_freq override
--- user_files
>>> ../conf/test.js
function respond_with_delay(r) {
    setTimeout((r) => { r.return(200); }, 15000, r);
}
export default {respond_with_delay};
--- timeout: 20
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
    pinba_resolve_freq 30; # less than default 60 sec
    js_import test.js;
--- config
    location /foo {
        pinba_resolve_freq 10; # override http scope directive
        js_content test.respond_with_delay; # and make a sleep here
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] request hostname: .*/,
    qr/\[debug\] .* \[pinba\] request script_name: \/foo/,
    qr/\[debug\] .* \[pinba\] request schema: http/,
    qr/\[debug\] .* \[pinba\] server 127.0.0.1:33333 re-resolve after 10 sec/,
]

=== basic: pinba_ignore_codes simple
--- http_config
    pinba_enable on;
    pinba_ignore_codes 200;
--- config
    location /foo {
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] ignoring response code 200/,
]

=== basic: pinba_ignore_codes override
--- http_config
    pinba_enable on;
    pinba_ignore_codes 200;
--- config
    location /foo {
        pinba_ignore_codes 404;
        return 404;
    }
--- request
    GET /foo
--- error_code: 404
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] ignoring response code 404/,
]
