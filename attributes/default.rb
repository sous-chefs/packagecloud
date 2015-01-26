default['packagecloud']['base_repo_url'] = 'https://packagecloud.io'
default['packagecloud']['base_url'] = "#{default['packagecloud']['base_repo_url']}/install/repositories/"
default['packagecloud']['gpg_key_url'] = "#{default['packagecloud']['base_repo_url']}/gpg.key"

default['packagecloud']['default_type'] = value_for_platform_family(
  'debian' => 'deb',
  ['rhel', 'fedora'] => 'rpm'
)
