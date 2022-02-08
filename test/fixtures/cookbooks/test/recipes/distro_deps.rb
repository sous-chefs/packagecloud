case node['platform_family']
when 'rhel', 'fedora', 'amazon'

  # TODO: Use the EPEL cookbook
  yum_repository 'epel5' do
    baseurl 'https://mirrors.rit.edu/fedora/archive/epel/5/$basearch'
    description 'Extra Packages for Enterprise Linux 5 - $basearch'
    enabled true
    gpgcheck true
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  end

  package %w(ruby rubygems)

when 'debian'
  apt_update
  package %w(ruby dpkg-dev rubygems)
end
