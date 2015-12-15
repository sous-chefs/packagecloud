packagecloud_repo 'computology_public_deb_with_gpg_key' do
  repository 'computology/packagecloud-cookbook-test-public'
  type 'deb'
  gpg_key 'packagecloud.gpg.key'
end
