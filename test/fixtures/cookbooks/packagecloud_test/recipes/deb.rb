packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  type 'deb'
end

package 'jake'

packagecloud_repo 'computology/packagecloud-cookbook-test-private' do
  type 'deb'
  master_token '762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9'
end

package 'jake-doc'

execute 'install_jake_source' do
  cwd '/home/vagrant'
  command 'apt-get source jake'
end
