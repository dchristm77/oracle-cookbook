#
# Cookbook Name:: oracle
# Recipe:: create_database
#
# Copyright 2013, Nike
#
# All rights reserved - Do Not Redistribute
#

template "/opt/oracle/otk/1.0/conf/installManager/dbSetup-chef.cfg" do
    source "dbSetup.cfg.erb"
    mode 00644
    owner "oracle"
    group "oinstall"
    backup false
end

file "/opt/oracle/otk/home/installOracleDatabase.ksh" do
    owner "oracle"
    group "oinstall"
    mode 00755
    action :create
    backup false
    content <<-EOH
      cd ${INSTALL_CONF} && \
      installManager dbSetup dbSetup-chef.cfg
    EOH
end

execute "install-oracle-database" do
    command "su oracle -l -c 'ksh -x /opt/oracle/otk/home/installOracleDatabase.ksh'"
    not_if do 
        Chef::Log.debug("database name: #{node[:oracle][:database][:db_name]}")
        cmd = Chef::ShellOut.new("grep #{node[:oracle][:database][:db_name]} /etc/oratab").run_command
        cmd.exitstatus == 0
    end
end

template "/etc/oratab" do
    source "oratab.erb"
    owner "oracle"
    group "oinstall"
    mode 00664
end
