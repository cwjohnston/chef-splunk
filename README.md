Description
===========

This cookbook automates retrieval, installation and configuration of a packaged version of Splunk from splunk.com. 

Requirements
============
As of this writing (version 0.1) Debian and Ubuntu are the only supported distributions. Patches to are welcome!

Recipes
=======

default.rb
----------

The default recipe retrieves a packaged version of the splunk data indexing, montioring, reporting and analysis software from splunk.com. The version of the package retrieved is constructed from the value set in `node[:splunk][:version]` and the machine architecture stored in `node[:kernel]
[:machine]`. The splunk service is configured to start at boot time with a default configuration.

Documentation for splunk is available at [splunk.com](http://www.splunk.com/base/Documentation/latest/Admin/)


apache_proxy.rb
---------------

When using the free Splunk license, authentication is not supported. This recipe implements a simple apache2 vhost on port 80 to proxy requests to your Splunk instance with basic HTTP authentication.

Attributes
==========
`splunk[:root]` - Sets the root directory of the splunk installation; splunk documentation refers to this as `$SPLUNK_HOME`. Defaults to /opt/splunk. Changing this value is not a good idea when installing from packages but it might actually be used by future installation methods.

`splunk[:version]` - Sets the version number of the desired splunk package to download and install in the format "N.N.N-NNNN". Defaults to latest as of cookbook release.

`splunk[:proxy_user]` - Sets the username for basic HTTP authentication when using `splunk::apache_proxy`. Default is 'admin' matching the default splunk username.

`splunk[:proxy_pass]` - Sets the hashed password for basic HTTP authentication when using `splunk::apache_proxy`. Default is hashed value for 'changeme' matching the default splunk password.

Future Plans
============
* Consider using tarball install to simplify support for all distributions.
* Add support for configuring some general splunk parameters via attributes (e.g., web-port, splunkd-port, servername, datastore-dir, minfreemb).
* Add support for configuring logins via a data bag.
* Determine some method for automatically configuring splunk to use the built-in free license (splunk 4.2 and greater no longer respects the `$SPLUNK_HOME/etc/splunk.license` file).
* Add SSL support to `splunk::apache_proxy`.
* Consider refactoring `splunk::apache_proxy` to support other httpds (i.e. nginx).
* Add recipes for non-indexer configurations (e.g., distributed search head, forwarder, heavy forwarder, light forwarder).

License and Author
==================

Author:: Cameron Johnston (<cameron@needle.com>)

Copyright:: 2011, Needle, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
