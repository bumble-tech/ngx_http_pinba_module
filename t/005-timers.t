#!/usr/bin/perl

use Test::Nginx::Socket 'no_plan';

no_shuffle();

run_tests();

__DATA__

=== timers: server level
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    pinba_timer 1.0 1 {
        group db;
        uri $uri;
    }
    location /foo {
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] timer #0 value and hit count:  1.000, 1/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: uri = \/foo/,
]

=== timers: location level
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    location /foo {
        pinba_timer 1.0 1 {
            group db;
            uri $uri;
        }
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] timer #0 value and hit count:  1.000, 1/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: uri = \/foo/,
]

=== timers: merge two levels
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
--- config
    pinba_timer 1.0 1 {
        group db;
        uri $uri;
    }
    location /foo {
	    pinba_timer 2.0 2 {
            group db;
	        uri $uri;
	    }
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] timer #0 value and hit count:  2.000, 2/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: uri = \/foo/,
    qr/\[debug\] .* \[pinba\] timer #1 value and hit count:  1.000, 1/,
    qr/\[debug\] .* \[pinba\] timer #1 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #1 tag: uri = \/foo/,
]

=== timers: merge three levels
--- http_config
    pinba_enable on;
    pinba_server "127.0.0.1:33333";
    pinba_timer 1.0 1 {
        group db;
        uri $uri;
    }
--- config
    pinba_timer 2.0 2 {
        group db;
        uri $uri;
    }
    location /foo {
        pinba_timer 3.0 3 {
            group db;
            uri $uri;
        }
        return 200;
    }
--- request
    GET /foo
--- error_code: 200
--- error_log eval
[
    qr/\[debug\] .* \[pinba\] http handler/,
    qr/\[debug\] .* \[pinba\] timer #0 value and hit count:  3.000, 3/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #0 tag: uri = \/foo/,
    qr/\[debug\] .* \[pinba\] timer #1 value and hit count:  2.000, 2/,
    qr/\[debug\] .* \[pinba\] timer #1 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #1 tag: uri = \/foo/,
    qr/\[debug\] .* \[pinba\] timer #2 value and hit count:  1.000, 1/,
    qr/\[debug\] .* \[pinba\] timer #2 tag: group = db/,
    qr/\[debug\] .* \[pinba\] timer #2 tag: uri = \/foo/,
]
