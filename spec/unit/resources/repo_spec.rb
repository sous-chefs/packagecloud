# frozen_string_literal: true

require 'spec_helper'

describe 'packagecloud_repo' do
  step_into :packagecloud_repo

  let(:http) { instance_double(Net::HTTP) }
  let(:gpg_response) do
    Net::HTTPOK.new('1.1', '200', 'OK').tap do |response|
      allow(response).to receive(:body).and_return("https://packagecloud.io/test/repo/gpgkey\n")
    end
  end
  let(:rpm_base_response) do
    Net::HTTPOK.new('1.1', '200', 'OK').tap do |response|
      allow(response).to receive(:body).and_return("https://packagecloud.io/test/repo/el/9/$basearch\n")
    end
  end

  before do
    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:use_ssl=)
    allow(http).to receive(:ca_file=)
    allow(http).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(gpg_response)
  end

  context 'on ubuntu' do
    platform 'ubuntu', '24.04'

    context 'with default properties' do
      recipe do
        packagecloud_repo 'test/repo' do
          force_os 'any'
          force_dist 'any'
        end
      end

      it { is_expected.to install_package('wget') }
      it { is_expected.to install_package('apt-transport-https') }
      it { is_expected.to install_package('lsb-release') }
      it { is_expected.to create_template('/etc/apt/sources.list.d/test_repo.list') }
      it { is_expected.to_not run_execute('apt-key-add-test_repo') }
      it { is_expected.to_not run_execute('apt-get-update-test_repo') }
    end

    context 'with action :remove' do
      recipe do
        packagecloud_repo 'test/repo' do
          type 'deb'
          action :remove
        end
      end

      it { is_expected.to delete_file('/etc/apt/sources.list.d/test_repo.list') }
      it { is_expected.to_not update_apt_update('apt-get-update-test_repo') }
    end
  end

  context 'on almalinux' do
    platform 'almalinux', '9'

    before do
      allow(http).to receive(:request).and_return(rpm_base_response, gpg_response)
    end

    context 'with rpm defaults' do
      recipe do
        packagecloud_repo 'test/repo'
      end

      it { is_expected.to create_template('/etc/yum.repos.d/test_repo.repo') }
      it { is_expected.to_not run_execute('yum-makecache-test_repo') }
      it { is_expected.to_not run_ruby_block('yum-cache-reload-test_repo') }
    end

    context 'with action :remove' do
      recipe do
        packagecloud_repo 'test/repo' do
          type 'rpm'
          action :remove
        end
      end

      it { is_expected.to delete_file('/etc/yum.repos.d/test_repo.repo') }
      it { is_expected.to_not run_execute('yum-makecache-test_repo') }
      it { is_expected.to_not run_ruby_block('yum-cache-reload-test_repo') }
    end
  end

  context 'with gem source' do
    platform 'ubuntu', '24.04'

    context 'with action :add' do
      stubs_for_provider('packagecloud_repo[test/repo]') do |provider|
        allow(provider).to receive(:gem_sources).and_return([])
      end

      recipe do
        packagecloud_repo 'test/repo' do
          type 'gem'
        end
      end

      it { is_expected.to run_ruby_block('install packagecloud test/repo repo as gem source') }
    end

    context 'with action :remove' do
      stubs_for_provider('packagecloud_repo[test/repo]') do |provider|
        allow(provider).to receive(:gem_sources).and_return(configured_sources)
        expect(provider).to receive(:gem_sources_command).with('--remove', configured_sources.first).and_return(double(error!: nil))
        expect(provider).to receive(:gem_sources_command).with('--remove', configured_sources[1]).and_return(double(error!: nil))
      end

      let(:configured_sources) do
        %w(https://packagecloud.io/test/repo/ https://stale-token:@packagecloud.io/test/repo/ https://packagecloud.io/test/repo-other/)
      end

      recipe do
        packagecloud_repo 'test/repo' do
          type 'gem'
          action :remove
        end
      end

      it 'removes public and authenticated variants while preserving a sibling repository' do
        chef_run.ruby_block('remove packagecloud test/repo repo as gem source').block.call
      end
    end

    context 'with an authenticated source' do
      stubs_for_provider('packagecloud_repo[test/repo]') do |provider|
        allow(provider).to receive(:post).and_return(instance_double(Net::HTTPOK, body: "current-token\n"))
        allow(provider).to receive(:gem_sources).and_return(configured_sources)
      end

      recipe do
        packagecloud_repo 'test/repo' do
          type 'gem'
          master_token 'fixture-master-token'
        end
      end

      context 'when only public and stale credentials are registered' do
        let(:configured_sources) do
          %w(https://packagecloud.io/test/repo/ https://stale-token:@packagecloud.io/test/repo/)
        end

        it { is_expected.to run_ruby_block('install packagecloud test/repo repo as gem source') }
      end

      context 'when the exact authenticated URL is registered' do
        let(:configured_sources) { ['https://current-token:@packagecloud.io/test/repo/'] }

        it { is_expected.not_to run_ruby_block('install packagecloud test/repo repo as gem source') }
      end
    end
  end
end
