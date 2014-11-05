packagecloud_repo 'chef/stable' do
  supported_codenames ['natty', 'raring', 'saucy']
  default_codename 'lucid'
end

packagecloud_repo 'basho/riak-cs'

packagecloud_repo 'basho/riak' do
  default_codename 'precise'
end
