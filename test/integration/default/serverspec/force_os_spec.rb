require 'spec_helper'

describe file('/etc/apt/sources.list.d/computology_packagecloud-test-packages.list'), if: os[:family] == 'ubuntu' do
  it { should exist }
  its(:content) { should include 'wheezy' }
end
