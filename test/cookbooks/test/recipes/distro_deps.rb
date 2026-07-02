# frozen_string_literal: true

package 'ca-certificates'

if platform_family?('debian')
  package %w(ruby dpkg-dev rubygems)
end
