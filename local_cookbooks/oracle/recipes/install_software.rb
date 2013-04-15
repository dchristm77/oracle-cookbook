#
# Cookbook Name:: oracle
# Recipe:: default
#
# Copyright 2013, Nike
#
# All rights reserved - Do Not Redistribute
#

directory "/var/tmp/oracle" do
    owner "root"
    group "root"
    mode 00755
    action :create
end

cookbook_file "/var/tmp/oracle/oratoolkit-1.0.2.1.5-1.noarch.rpm" do
    source "oratoolkit-1.0.2.1.5-1.noarch.rpm"
    mode 00644
    action :create_if_missing
end

yum_package "ksh.i686" 
yum_package "ruby-shadow.i686"
yum_package "unzip.i686"

yum_package "oratoolkit" do
    source "/var/tmp/oracle/oratoolkit-1.0.2.1.5-1.noarch.rpm"
end

# Set password to "vagrant"
user "oracle" do
    password "$1$iE1ld90m$Srt1vb3yxfQuXOOPd.Avm1"
    action :modify
end

bash "install-dependent-packages" do
    user "root"
    code <<-EOF
      # Generate yum command
      REQ_FILE_DIR="/opt/oracle/otk/current/conf/installManager/requirement"
      REQ_FILE_PATH="$REQ_FILE_DIR/ora11gR2-redhat-6-x86.pkg.lst"
      YUM_COMMAND=$(echo "yum install -y")
      YUM_COMMAND+=$(egrep -v "#" $REQ_FILE_PATH | grep 32-bit | awk '{ print " "$1".i[356]86" }')
      YUM_COMMAND+=$(egrep -v "#" $REQ_FILE_PATH | grep 64-bit | awk '{ print " "$1".x86_64" }')
      # Display yum command
      echo $YUM_COMMAND
      # Execute yum command
      $YUM_COMMAND
    EOF
end 

bash "os-setup" do
    user "root"
    code <<-EOF
      /opt/oracle/otk/current/bin/installManager osSetup osSetup11gR2.cfg
    EOF
end

cookbook_file "/var/opt/oracle/repository/linux_11gR2_database_1of2.zip" do
    source "linux_11gR2_database_1of2.zip"
    owner "oracle"
    group "oinstall"
    mode 00644
    action :create_if_missing
    not_if { File.exist?("/opt/oracle/eesrv/11.2.0/db1") }
end

cookbook_file "/var/opt/oracle/repository/linux_11gR2_database_2of2.zip" do
    source "linux_11gR2_database_2of2.zip"
    owner "oracle"
    group "oinstall"
    mode 00644
    action :create_if_missing
    not_if { File.exist?("/opt/oracle/eesrv/11.2.0/db1") }
end

ruby_block "set-site-name-in-oracle-profile" do
    block do
        pf = Chef::Util::FileEdit.new("/opt/oracle/otk/home/.profile.custom.interactive")
        pf.search_file_replace(/<SITE\|COMPANY>/, "NikeTF")
        pf.write_file
    end
end

bash "run-root-script" do
    user "root"
    code <<-EOF
      /opt/oracle/eesrv/11.2.0/db1/root.sh
    EOF
    action :nothing
end

file "/opt/oracle/otk/home/installOracleSoftware.ksh" do
    owner "oracle"
    group "oinstall"
    mode "0755"
    action :create
    backup false
    content <<-EOH
      cd ${INSTALL_CONF} && \
      cp sample/swInstEeSrv11gR2-Step1-linux-x86.cfg ./ && \
      installManager swInst swInstEeSrv11gR2-Step1-linux-x86.cfg
    EOH
end

execute "install-oracle-software" do
    command "su oracle -l -c 'ksh -x /opt/oracle/otk/home/installOracleSoftware.ksh'"
    creates "/opt/oracle/eesrv/11.2.0/db1"
    notifies :run, "bash[run-root-script]", :immediately
end

# Do some cleanup
file "/var/opt/oracle/repository/linux_11gR2_database_1of2.zip" do
    action :delete
end

file "/var/opt/oracle/repository/linux_11gR2_database_2of2.zip" do
    action :delete
end
