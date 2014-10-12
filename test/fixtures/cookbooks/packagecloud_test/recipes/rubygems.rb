packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  type 'gem'
end

gem_package 'jakedotrb' do
  options "--bindir /usr/local/bin"
  version '0.0.1'
end
