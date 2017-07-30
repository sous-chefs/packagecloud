case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package 'ruby'
  package 'rubygems'
when 'debian'
  apt_update
  package 'ruby'
  package 'dpkg-dev'
end
