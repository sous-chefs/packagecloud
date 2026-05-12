# frozen_string_literal: true

apt_update

include_recipe 'test::distro_deps'

packagecloud_repo 'damacus/packagecloud-test' do
  if platform_family?('debian')
    force_os 'ubuntu'
    force_dist 'jammy'
  elsif platform?('amazon')
    force_os 'el'
    force_dist '9'
  elsif platform_family?('rhel')
    force_os 'el'
    force_dist node['platform_version'].to_i.to_s
  end
end

if platform_family?('debian')
  packagecloud_repo 'damacus/packagecloud-test' do
    type 'gem'
  end
end
