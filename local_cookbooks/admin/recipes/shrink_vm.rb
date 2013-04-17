#
# Cookbook Name:: admin
# Recipe:: shrink_vm
#
# Copyright 2013, NIKE
#
# All rights reserved - Do Not Redistribute
#

bash "remove-empty-space" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      dd if=/dev/zero of=/EMPTY bs=1M
      rm -f /EMPTY
    EOH
end
