%w{ apache2 apache2::mod_proxy apache2::mod_proxy_http }.each do |r|
  include_recipe r
end

web_app "splunk_proxy" do
  template "splunk_proxy.erb"
end

apache_site "splunk_proxy"

apache_site "000-default" do
  enable false
end

if node[:splunk][:alt_htpasswd]
  template node[:splunk][:alt_htpasswd] do
    source "htpasswd.erb"
    owner node[:apache][:user]
    mode 0600
    not_if{File.exists?(node[:splunk][:alt_htpasswd])}
  end
else
  template "#{node[:splunk][:root]}/.htpasswd" do
    source "htpasswd.erb"
    owner node[:apache][:user]
    mode 0600
  end
end
