#
# Cookbook Name:: admin
# Recipe:: prep_for_pkg
#
# Copyright 2013, NIKE
#
# All rights reserved - Do Not Redistribute
#

# deleteing this file prevents a vagrant start error bringing up network interfaces in centos
file "/etc/udev/rules.d/70-persistent-net.rules" do
    action :delete
end

include_recipe "admin::shrink_vm"
