# `pacakgecloud_repo`

The packagecloud_repo resource manages the installation of package repositories on various systems, including Debian, RHEL, Fedora, and Amazon Linux. It supports deb, rpm, and gem package types.
Properties

The following table provides an overview of the available properties for packagecloud_repo:

| Property        | Type    | Description                                                                                    | Default                   |
|-----------------|---------|------------------------------------------------------------------------------------------------|---------------------------|
| repository      | String  | The name of the repository to install.                                                         |                           |
| master_token    | String  | The master token for the repository. This is only required for private repositories.           |                           |
| force_os        | String  | The OS to force for the repository. This is only required for some repositories.               |                           |
| force_dist      | String  | The distribution to force for the repository. This is only required for some repositories.     |                           |
| type            | String  | The type of repository to install. Valid values are `deb`, `rpm`, and `gem`.                   |                           |
| base_url        | String  | The base URL for the repository. This is only required for packagecloud:enterprise users.      | `https://packagecloud.io` |
| priority        | Integer | The priority of the repository. This is only required for Debian-based systems.                | false                     |
| metadata_expire | String  | The metadata expiration time for the repository. This is only required for RHEL-based systems. | 300                       |

## Examples

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test" do
  type "deb"
end
```

### Public Repository

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test-public"
```

### Private Repositories

For private repositories, you need to supply a `master_token`:

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test-private" do
  master_token "762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9"
end
```

### Enterprise Users

For packagecloud:enterprise users, add `base_url` to your resource:

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test-private" do
  base_url "https://packages.example.com"
  master_token "762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9"
end
```

### Force OS and Dist

For forcing the os and dist for repository install:

```ruby
packagecloud_repo 'computology/packagecloud-cookbook-test-public' do
  force_os 'rhel'
  force_dist '6.5'
end
```

This cookbook performs checks to determine if a package exists before attempting to install it. To enable proxy support _for these checks_ (not to be confused with proxy support for your package manager of choice), add the following attributes to your cookbook:

```ruby
default['packagecloud']['proxy_host'] = 'myproxy.organization.com'
default['packagecloud']['proxy_port'] = '80'
```
