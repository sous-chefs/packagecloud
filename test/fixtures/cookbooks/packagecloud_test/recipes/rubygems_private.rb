execute 'update apt' do
  command 'apt-get update'
end
package 'ruby'
package 'rubygems'

packagecloud_repo 'computology/packagecloud-cookbook-test-private' do
  type 'gem'
  master_token '762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9'
end

gem_package 'jakedotrb' do
  version '0.0.1'
end
