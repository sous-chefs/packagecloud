require 'spec_helper'

describe 'supported-codenames' do
  describe file('/etc/apt/sources.list.d/chef_stable.list') do
    its(:content) { should match %r[deb https://packagecloud.io/chef/stable/ubuntu lucid main] }
  end

  describe file('/etc/apt/sources.list.d/basho_riak-cs.list') do
    its(:content) { should match %r[deb https://packagecloud.io/basho/riak-cs/ubuntu \w+ main] }
  end

  describe file('/etc/apt/sources.list.d/basho_riak.list') do
    its(:content) { should match %r[deb https://packagecloud.io/basho/riak/ubuntu precise main] }
  end

end
