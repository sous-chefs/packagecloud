require 'spec_helper'

sources_content = "deb https://packagecloud.io/computology/packagecloud-test-packages/debian wheezy main\ndeb-src https://packagecloud.io/computology/packagecloud-test-packages/debian wheezy main\n"

describe file('/etc/apt/sources.list.d/computology_packagecloud-test-packages.list'), if: os[:family] == 'ubuntu' do
  it { should exist }
  its(:content) { should eq sources_content }
end
