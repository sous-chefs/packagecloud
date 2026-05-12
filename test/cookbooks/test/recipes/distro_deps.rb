# frozen_string_literal: true

if platform_family?('debian')
  package %w(ruby dpkg-dev rubygems)
end
