return unless ["ubuntu", "debian"].include?(node[:platform]) # this cookbook is currently designed for ubuntu. patches welcome!

pkg_arch = nil
short_ver = nil

case node[:kernel][:machine]
when "x86_64"
  pkg_arch = "amd64"
when "i686"
  pkg_arch = "intel"
else
  raise "seems that your system's architecture is neither i686 nor amd64; no dice."
end

short_ver=node[:splunk][:version].match(/\d.\d.\d/).to_s

remote_file "/usr/src/splunk-#{node[:splunk][:version]}-linux-2.6-#{pkg_arch}.deb" do
  source "http://www.splunk.com/index.php/download_track?file=#{short_ver}/splunk/linux/splunk-#{node[:splunk][:version]}-linux-2.6-#{pkg_arch}.deb&ac=wiki_download&wget=true&name=wget&typed=releases"
  not_if{File.exists?("/usr/src/splunk-#{node[:splunk][:version]}-linux-2.6-#{pkg_arch}.deb")}
end

dpkg_package "splunk" do
  action :install
  source "/usr/src/splunk-#{node[:splunk][:version]}-linux-2.6-#{pkg_arch}.deb"
end

service "splunk" do
  supports :status => true, :restart => true, :reload => false
  start_command "#{node[:splunk][:root]}/bin/splunk start --accept-license"
  stop_command "#{node[:splunk][:root]}/bin/splunk stop"
  restart_command "#{node[:splunk][:root]}/bin/splunk restart --accept-license"
  status_command "#{node[:splunk][:root]}/bin/splunk status"
  action [ :start ]
  running true
end

bash "enable_boot" do
  user "root"
  code <<-EOH
  #{node[:splunk][:root]}/bin/splunk start --accept-license
  #{node[:splunk][:root]}/bin/splunk enable boot-start
  EOH
  not_if{File.exists?("/etc/init.d/splunk")}
end
