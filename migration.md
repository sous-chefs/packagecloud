# Migration

## Migrating to resource properties

This release removes the legacy node attributes under `node['packagecloud']`.
Wrapper cookbooks should configure `packagecloud_repo` properties directly.

* `node['packagecloud']['base_repo_path']` becomes `base_repo_path`.
* `node['packagecloud']['gpg_key_path']` becomes `gpg_key_path`.
* `node['packagecloud']['hostname_override']` becomes `hostname_override`.
* `node['packagecloud']['proxy_host']` becomes `proxy_host`.
* `node['packagecloud']['proxy_port']` becomes `proxy_port`.

Before:

```ruby
node.default['packagecloud']['proxy_host'] = 'myproxy.organization.com'
node.default['packagecloud']['proxy_port'] = '80'

packagecloud_repo 'computology/packagecloud-cookbook-test-public'
```

After:

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  proxy_host 'myproxy.organization.com'
  proxy_port '80'
end
```

## Test cookbook examples

See `test/cookbooks/test/recipes/default.rb` for current resource examples used
by Kitchen.
