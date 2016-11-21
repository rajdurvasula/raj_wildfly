#
# Cookbook Name:: raj_wildfly
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'java'

wildfly=node['wildfly']

# create user 'wildfly' with password 'wildfly'
user wildfly['user'] do
 comment 'wildfly user'
 home wildfly['home']
 shell '/bin/bash'
 password '$1$wildfly$uQEGHfrNGrwgLGjdGWVzV.'
 action [:create, :lock]
end

# create group
group wildfly['group'] do
  append true
  members wildfly['user']
  action :create
end

# create wildfly directory and assign user
directory wildfly['home'] do
  owner wildfly['user']
  group wildfly['group']
  mode 0755
  recursive true
end

package 'libaio' do
  action :install
end

# Download wildfly installer
remote_file "#{Chef::Config[:file_cache_path]}/#{wildfly['version']}.tar.gz" do
  source wildfly['download_url']
  checksum wildfly['checksum']
  action :create
  notifies :run, 'bash[Install Wildfly]', :immediately 
end 

bash 'Install Wildfly' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar xzf #{wildfly['version']}.tar.gz -C #{wildfly['home']} --strip 1
  chown #{wildfly['user']}:#{wildfly['group']} -R #{wildfly['home']}
  EOF
  action :run
end

template ::File.join(::File::SEPARATOR, 'etc', 'init.d', wildfly['service']) do
  source 'wildfly-init-rhel.sh.erb'
  user 'root'
  group 'root'
  mode '0755'
end

template ::File.join(::File::SEPARATOR, 'etc', 'default', 'wildfly.conf') do
  source 'wildfly.conf.erb'
  user 'root'
  group 'root'
  mode '0644'
end

template ::File.join(wildfly['home'], 'standalone', 'configuration', wildfly['sa']['conf']) do
  source "#{wildfly['sa']['conf']}.erb"
  user wildfly['user']
  group wildfly['group']
  mode '0644'
  variables(
    port_binding_offset: wildfly['int']['port_binding_offset'],
    mgmt_int: wildfly['int']['mgmt']['bind'],
    mgmt_http_port: wildfly['int']['mgmt']['http_port'],
    mgmt_https_port: wildfly['int']['mgmt']['https_port'],
    pub_int: wildfly['int']['pub']['bind'],
    pub_http_port: wildfly['int']['pub']['http_port'],
    pub_https_port: wildfly['int']['pub']['https_port'],
    wsdl_int: wildfly['int']['wsdl']['bind'],
    ajp_port: wildfly['int']['ajp']['port'],
    acp: wildfly['acp']
  )
  notifies :restart, "service[#{wildfly['service']}]", :delayed
  only_if { !::File.exist?(::File.join(wildfly['home'],'.chef_deployed')) || wildfly['enforce_config'] }
end

template ::File.join(wildfly['home'],'standalone','configuration','mgmt-users.properties') do
  source 'mgmt-users.properties.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  variables(
    mgmt_users: wildfly['users']['mgmt']
  )
end

template ::File.join(wildfly['home'],'standalone','configuration','application-users.properties') do
  source 'application-users.properties.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  variables(
    app_users: wildfly['users']['app']
  )
end

template ::File.join(wildfly['home'],'standalone','configuration','application-roles.properties') do
  source 'application-roles.properties.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  variables(
    app_roles: wildfly['roles']['app']
  )
end

# create file to indicate deployment in progress and prevent recurring configuration deployment
file ::File.join(wildfly['home'], '.chef_deployed') do
  owner wildfly['user']
  group wildfly['group']
  action :create_if_missing
end

service wildfly['service'] do
  action :start
end
