#
# Cookbook Name:: admin
# Recipe:: update
#
# Copyright 2013, NIKE
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.debug("proxy = " + node[:yum][:proxy])
ENV['http_proxy'] = node[:yum][:proxy]

cookbook_file "/tmp/rpmforge-release-0.5.3-1.el6.rf.i686.rpm" do
    backup false
    action :create_if_missing
    source "rpmforge-release-0.5.3-1.el6.rf.i686.rpm"
end

package "rpmforge-release-0.5.3-1.el6.rf.i686" do
    action :install
    source "/tmp/rpmforge-release-0.5.3-1.el6.rf.i686.rpm"
end

package "dkms" do
    action :install
end

update = Mixlib::ShellOut.new("yum update -y")
update.run_command
Chef::Log.info(update.stdout)
update.error!

