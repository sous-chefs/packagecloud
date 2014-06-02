# packagecloud cookbook

This cookbook provides an LWRP for installing https://packagecloud.io repositories.

## Usage

For public repos:

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test-public" do
  type "deb"
end
```

For private repos, you need to supply a `master_token`:

```ruby
packagecloud_repo "computology/packagecloud-cookbook-test-private" do
  type "deb"
  master_token "762748f7ae0bfdb086dd539575bdc8cffdca78c6a9af0db9"
end
```

Valid options for `type` include `deb`, `rpm`, and `gem`.

## Credits

Written by James Golick, Computology, LLC.
