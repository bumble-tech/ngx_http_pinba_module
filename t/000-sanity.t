use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: vars
--- http_config
    pinba_enable on;
--- config
    location /foo {
        return 418;
    }
--- request
    GET /foo
--- error_code: 418
