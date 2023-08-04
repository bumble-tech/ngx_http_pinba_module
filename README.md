Pinba module for nginx
======================

What
----
This is a Pinba module for Nginx. It sends statistics packets by UDP that are received and processed by Pinba server to be accessible through MySQL interface.
See <http://pinba.org> for more details on how Pinba works.

Why
---
Because PHP stats are simply not enough, and we want to see some more info directly from Nginx servers.
HTTP status codes stats were among the main reasons, but there is a lot more data than that.
And more data means more nice graphs, yay!

Pre-requisites
--------------
Nginx sources, C compiler.

Installation
------------
Add this to your Nginx configure line:  

`--add-module=/path/to/ngx_http_pinba_module.git/`  

and then do `make install`.

Development and testing
-----------------------

For development purposes you can use `build.sh` script.
To run tests you can use `test.sh` script.

Configuration options
---------------------
All configuration options must be added to the `http {}` section of the config file,
but you can always modify them in location/server sections.

`pinba_enable` - on/off.
The module is disabled by default.

`pinba_server` - the address of Pinba server.  
Should be a valid `host:port` or `ip_address:port` combination.
You can add several of these separated by space. In that case the same data will be sent to all of these.

`pinba_resolve_freq` - integer (seconds).
Resolve frequency for pinba server hostname. The module will try to re-resolve the hostname each N seconds to make sure it's up-to-date.
Zero (0) means immediate re-resolve.
Default value: 60 seconds.

`pinba_ignore_codes` - a list of HTTP status codes.  
Can be comma separated list or comma separated ranges of codes or both.  
No data packet will be sent if a request is finished with a final status from the list.

Example:  
`pinba_ignore_codes 200-399,499;`

Make sure there are no spaces between the values, though.

`$pinba_request_uri` - variable.
Use this variable to specify custom script name value, the module always checks if this variable is defined and if it is, uses it.
The default value is Nginx `$request_uri` variable without its GET parameters.

`$pinba_hostname` - variable.
Use this variable to specify custom hostname value, the module always checks if this variable is defined and if it is, uses it.
The default value is the result of gethostname() function.

`$pinba_request_schema` - variable.
Use this variable to specify custom HTTP schema, the module always checks if this variable is defined and if it is, uses it.
The default value is detected this way:

	if (r->connection->ssl) {
		/* schema = "https" */
	} else {
		/* schema = "http" */
	}

Request tags
------------
You can use request tags for tagging requests in the following way:

	pinba_tag country US;
	pinba_tag ua firefox;

Each request may feature an arbitrary number of tags, which could be using to create filtered reports in Pinba
(say, a report showing User-Agent distribution only for US, as in the example).

Timers
------
Timers provide a way to measure how much time it took to execute a certain part of the code.
Nginx, of course, doesn't have access to your code and cannot measure it automatically, but you can set the timer's value manually.
To do this, use the following syntax:

	pinba_timer 1.25 3 {
		server $hostname;
		group db;
	}

This will create new timer with a value = 1.25 sec, hit count = 3, and 3 tags: server, group with the appropriate values.
Variables are allowed for all parameters:

	pinba_timer $timer_value {
		$tag $value;
	}

Hit count is optional and set to 1 by default.
