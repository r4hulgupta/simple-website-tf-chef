#
# Cookbook:: rg_ws_deploy
# Recipe:: setup_webserver
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Enable and Start Apache
service 'httpd' do
  action [:enable, :start]
end

# Site path
landing_path = 'root/home'

# Document root directory
directory "/var/www/html/#{landing_path}" do
  recursive true
  mode '0755'
  action :create
end

template "/var/www/html/#{landing_path}/index.html" do
  source 'web_page.html.erb'
  mode '0755'
  action :create
 # notifies :restart, 'service[httpd]'
end
