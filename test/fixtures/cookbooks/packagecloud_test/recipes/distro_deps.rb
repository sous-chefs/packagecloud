case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  yum_repository 'epel5' do
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch'
    description 'Extra Packages for Enterprise Linux 5 - $basearch'
    enabled true
    gpgcheck true
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
    only_if { node['platform_version'].to_i == 5 }
  end
  package 'ruby'
  package 'rubygems'
when 'debian'
  apt_update
  package 'ruby'
  package 'dpkg-dev'
end
