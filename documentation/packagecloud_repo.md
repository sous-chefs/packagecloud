# packagecloud_repo

Manages packagecloud.io APT, YUM/DNF, and RubyGems repository sources.

## Actions

| Action    | Description                                   |
|-----------|-----------------------------------------------|
| `:add`    | Adds the repository source. Default action.   |
| `:remove` | Removes the repository source where possible. |

## Properties

| Property            | Type                         | Default                   | Description                                                      |
|---------------------|------------------------------|---------------------------|------------------------------------------------------------------|
| `repository`        | String                       | name property             | packagecloud repository path, such as `owner/repository`.        |
| `master_token`      | String                       | `nil`                     | Master token for private repositories.                           |
| `force_os`          | String                       | `nil`                     | Override the detected packagecloud OS name.                      |
| `force_dist`        | String                       | `nil`                     | Override the detected packagecloud distribution name.            |
| `type`              | String                       | platform family default   | Repository type: `deb`, `rpm`, or `gem`.                         |
| `base_url`          | String                       | `https://packagecloud.io` | Base URL for packagecloud Enterprise installs.                   |
| `base_repo_path`    | String                       | `/install/repositories/`  | packagecloud install API path.                                   |
| `gpg_key_path`      | String                       | `/gpgkey`                 | packagecloud GPG key path retained for wrapper compatibility.    |
| `hostname_override` | String, nil                  | `nil`                     | Hostname sent to packagecloud when Ohai cannot determine one.    |
| `proxy_host`        | String, nil                  | `nil`                     | Proxy host used for packagecloud API requests.                   |
| `proxy_port`        | String, Integer, nil         | `nil`                     | Proxy port used for packagecloud API requests.                   |
| `priority`          | Integer, true, false         | `false`                   | Optional YUM repository priority.                                |
| `metadata_expire`   | String                       | `300`                     | YUM metadata expiration value.                                   |

## Examples

### Public repository

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public'
```

### Private repository

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-private' do
  master_token '762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9'
end
```

### packagecloud Enterprise

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-private' do
  base_url 'https://packages.example.com'
  master_token '762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9'
end
```

### Force OS and distribution

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  force_os 'rhel'
  force_dist '9'
end
```

### Proxy packagecloud API requests

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  proxy_host 'myproxy.organization.com'
  proxy_port '80'
end
```

### Remove a repository

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  action :remove
end
```
