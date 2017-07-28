name             'packagecloud'
maintainer       'Joe Damato'
maintainer_email 'joe@packagecloud.io'
license          'Apache-2.0'
description      'Installs/Configures packagecloud.io repositories.'
long_description 'Installs/Configures packagecloud.io repositories.'
source_url       'https://github.com/computology/packagecloud-cookbook'
issues_url       'https://github.com/computology/packagecloud-cookbook/issues'
version          '0.3.0'

chef_version '>= 12.6'

%w( amazon centos fedora debian redhat suse opensuse ubuntu).each do |os|
  supports os
end
