yum_repository 'epel5' do
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch'
    description 'Extra Packages for Enterprise Linux 5 - $basearch'
    enabled true
    gpgcheck true
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
end
