case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  if node['platform_version'].to_i == 5
    yum_repository 'epel5' do
      mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch'
      description 'Extra Packages for Enterprise Linux 5 - $basearch'
      enabled true
      gpgcheck true
      gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
    end
  end
  package %w(ruby rubygems)
when 'debian'
  apt_update 'update'
  package %w(ruby dpkg-dev)
  package 'rubygems' unless node['platform_version'].to_f == 14.04
end
