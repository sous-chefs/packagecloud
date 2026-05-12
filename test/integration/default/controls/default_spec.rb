# frozen_string_literal: true

title 'Default Tests'

if os.family == 'debian'
  control 'packagecloud-apt-01' do
    impact 1.0
    title 'APT repository is configured'

    describe file('/etc/apt/sources.list.d/damacus_packagecloud-test.list') do
      it { should exist }
      its('content') { should match(%r{https://packagecloud.io/damacus/packagecloud-test/ubuntu jammy main}) }
    end
  end

  control 'packagecloud-gem-01' do
    impact 0.7
    title 'RubyGems source is configured'

    describe command('gem sources --list') do
      its('stdout') { should match(%r{https://packagecloud.io/damacus/packagecloud-test/}) }
    end
  end
else
  control 'packagecloud-rpm-01' do
    impact 1.0
    title 'RPM repository is configured'

    describe file('/etc/yum.repos.d/damacus_packagecloud-test.repo') do
      it { should exist }
      its('content') { should match(%r{https://packagecloud.io/damacus/packagecloud-test/(el|fedora)/}) }
    end
  end
end
