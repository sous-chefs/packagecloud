include_recipe 'test::distro_deps'

if platform_family?('rhel', 'fedora', 'amazon')
  include_recipe 'test::rpm'
else
  include_recipe 'test::deb'
end

include_recipe 'test::rubygems'
include_recipe 'test::rubygems_private'
