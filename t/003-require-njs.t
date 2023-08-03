#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

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
