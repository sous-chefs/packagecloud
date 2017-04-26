apt_update

case node['platform']
when 'centos', 'fedora'
  package 'ruby'
  package 'rubygems'
when 'ubuntu'
  package 'ruby'
  package 'dpkg-dev'
end
