default['packagecloud']['base_repo_url'] = 'https://packagecloud.io/'
default['packagecloud']['base_url'] = 'https://packagecloud.io/install/repositories/'
default['packagecloud']['default_type'] = value_for_platform_family(
  'debian' => 'deb',
  ['rhel', 'fedora'] => 'rpm'
)
