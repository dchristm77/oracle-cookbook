#
# Cookbook Name:: oracle
# Attributes: default
#
# Copyright 2013, Nike
#
# All rights reserved - Do Not Redistribute
#

default[:oracle][:oratoolkit][:version] = '1.0.2.1.5-1'
default[:oracle][:owner] = 'oracle'
default[:oracle][:version] = '11.2.0'
default[:oracle][:home] = '/opt/oracle/eesrv/11.2.0/db1'

# Database creation attributes
default[:oracle][:database][:db_name] = 'default'
default[:oracle][:database][:password_sys] = 'vagrant'
default[:oracle][:database][:password_system] = 'vagrant'
# One of DEVELOPMENT, TEST, PRODUCTION
default[:oracle][:database][:db_usage] = 'DEVELOPMENT'
default[:oracle][:database][:log_archive_enabled] = 'FALSE'
default[:oracle][:database][:listener_port] = '1521'
# Prod configuration uses 512M for both the below in default otk setup
default[:oracle][:database][:memory_target] = '356M'
default[:oracle][:database][:memory_max_target] = '356M'

