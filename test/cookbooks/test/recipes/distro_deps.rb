# frozen_string_literal: true

package 'ca-certificates' do
  not_if 'rpm -q ca-certificates'
  only_if { platform_family?('amazon', 'fedora', 'rhel') }
end

package 'ca-certificates' do
  not_if { platform_family?('amazon', 'fedora', 'rhel') }
end

if platform_family?('debian')
  package %w(ruby dpkg-dev rubygems)
end
