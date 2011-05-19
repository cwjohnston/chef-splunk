maintainer        "Cameron Johnston"
maintainer_email  "cameron@needle.com"
license           "Apache 2.0"
description       "Installs and configures splunk"
version           "0.1.1"
depends           "apache2" # for apache_proxy recipe
recipe            "splunk", "Default splunk indexer configuration"
recipe            "splunk::apache_proxy", "Configures Apache to proxy for splunk on port 80 with HTTP basic auth"

attribute         "splunk/home",
  :display_name => "splunk root directory",
  :description => "Directory path where splunk is installed, aka $SPLUNK_HOME",
  :default => "/opt/splunk"

attribute         "splunk/version",
  :display_name => "splunk version",
  :description => "Desired version number for splunk installation",
  :default => "latest available"

attribute         "splunk/proxy_user",
  :display_name => "Apache proxy username",
  :description => "Username for authenticating with splunk when using splunk::apache_proxy recipe",
  :default => "admin"

attribute         "splunk/proxy_pass",
  :display_name => "Apache proxy password",
  :description => "Password for authenticating with splunk when using splunk::apache_proxy recipe",
  :default => "hashed value for changeme"

attribute         "splunk/alt_htpasswd",
  :display_name => "Apache proxy htpasswd path",
  :description => "Path to an alternate htpasswd file for authenticating to splunk when using splunk::apache_proxy recipe",
  :default => "false"
