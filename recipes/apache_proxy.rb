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

if node[:splunk][:bind_all_interfaces]
  # if bind to localhost is present, remove it
  execute "Update bind settings in #{node[:splunk][:root]}/etc/splunk-launch.conf to allow bind on all interfaces" do
    command "mv #{node[:splunk][:root]}/etc/splunk-launch.conf #{node[:splunk][:root]}/etc/splunk-launch.conf.backup; sed '/SPLUNK_BINDIP=127.0.0.1/d' #{node[:splunk][:root]}/etc/splunk-launch.conf.backup > #{node[:splunk][:root]}/etc/splunk-launch.conf"
    notifies :restart, resources(:service => "splunk")
    only_if "grep '^[[:space:]]*SPLUNK_BINDIP=127.0.0.1' #{node[:splunk][:root]}/etc/splunk-launch.conf"
  end
else
  # if bind to localhost is not present, add it
  execute "Update bind settings in #{node[:splunk][:root]}/etc/splunk-launch.conf to allow bind only on 127.0.0.1" do
    command "echo '\nSPLUNK_BINDIP=127.0.0.1\n' >> #{node[:splunk][:root]}/etc/splunk-launch.conf"
    notifies :restart, resources(:service => "splunk")
    not_if "grep '^[[:space:]]*SPLUNK_BINDIP=127.0.0.1' #{node[:splunk][:root]}/etc/splunk-launch.conf"
  end
end  