if platform_family?('rhel')
  include_recipe 'test::rpm'
else
  include_recipe 'test::deb'
end

include_recipe 'test::rubygems'
include_recipe 'test::rubygems_private'
