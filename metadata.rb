name 'packagecloud'
maintainer 'Joe Damato'
maintainer_email 'joe@packagecloud.io'
license 'Apache-2.0'
description 'Installs/Configures packagecloud.io repositories.'
version '1.0.1'
source_url 'https://github.com/computology/packagecloud-cookbook'
issues_url 'https://github.com/computology/packagecloud-cookbook/issues'
chef_version '>= 12.5'
%w(ubuntu debian redhat centos amazon oracle fedora scientific).each do |p|
  supports p
end
