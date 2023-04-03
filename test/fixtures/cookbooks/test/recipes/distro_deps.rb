case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package %w(ruby rubygems)
when 'debian'
  package %w(ruby dpkg-dev rubygems)
end
