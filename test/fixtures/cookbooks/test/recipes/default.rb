apt_update

include_recipe 'test::distro_deps'

packagecloud_repo 'damacus/packagecloud-test'

packagecloud_repo 'damacus/packagecloud-test-private' do
  master_token '81aa4bd4e1bcc8eac6daf9862c46965c538e0ff74456ddb7'
end

packagecloud_repo 'damacus/packagecloud-test' do
  type 'gem'
end

packagecloud_repo 'damacus/packagecloud-test-private' do
  type 'gem'
  master_token '81aa4bd4e1bcc8eac6daf9862c46965c538e0ff74456ddb7'
end

package 'jake' # Private
package 'packagecloud-test' # Public

# gem_package 'jakedotrb' do
#   options '--bindir /usr/local/bin'
#   version '0.0.1'
#   source 'https://packagecloud.io/damacus/packagecloud-test-private'
# end

gem_package 'packagecloud-test-gem' do
  source 'https://packagecloud.io/damacus/packagecloud-test'
  options '--bindir /opt/bin'
end
