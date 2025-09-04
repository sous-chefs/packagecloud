# packagecloud

This is the Changelog for the packagecloud cookbook

## Unreleased

## 2.0.9 - *2025-09-04*

## 2.0.8 - *2024-05-02*

## 2.0.7 - *2024-05-02*

## 2.0.6 - *2023-09-28*

## 2.0.5 - *2023-09-04*

## 2.0.4 - *2023-07-10*

## 2.0.3 - *2023-05-31*

## 2.0.2 - *2023-04-26*

- Add metadata check from the shard workflow

## 2.0.1 - *2023-04-03*

- Update README

## 2.0.0 - *2023-04-03*

- Sous Chefs Adoption
- Require Chef 15.3+
- Add standard files

## v1.0.1 (2018-10-25)

Fix issues with newer versions of Chef (11+) by conditionally defining `source_url` and `issues_url` in metadata.rb

## v1.0.0 (2018-03-12)

Lots of internal refactoring and fixes. Bumping the major number just incase,
but the changes should not break anyone using this cookbook.

## v0.3.0 (2017-03-08)

Fix force_os and force_dist for Ubuntu/Debian. Drop support for Ubuntu Lucid. Add support for Ubuntu Xenial. Ensure lsb_release is installed on Ubuntu/Debian.

## v0.2.5 (2016-08-11)

Check for empty node hostname. Display error when a node's fully qualified hostname is not set; as returned by `hostname -f`

## v0.2.4 (2016-07-05)

Add `proxy_host` and `proxy_port` attributes so that the cookbook can contact the packagecloud server.

## v0.2.3 (2016-06-01)

Try to fix `metadata_expire` type (set as String)

## v0.2.2 (2016-06-01)

Try to fix `metadata_expire` type (set as Integer)

## v0.2.1 (2016-05-31)

Set `metadata_expire` option to default of 300 (5 minutes) to match the generated configs produced by the bash and manual install instructions.

## v0.2.0 (2016-02-17)

Rework GPG paths to support new GPG endpoints for repos with repo-specific GPG keys. Old endpoints/URLs still work, too.

## v0.1.0 (2015-09-08)

packagecloud cookbook versions 0.0.19 used an attribute called `default['packagecloud']['hostname']` for caching the local machine's hostname to avoid regenerating read tokens.

This attribute has been removed as it is confusing and in some edge cases, buggy.

Beginning in 0.1.0, you can use `default['packagecloud']['hostname_override']` to specify a hostname if ohai is unable to determine the hostname of the node on its own.

## v0.0.1 (2014-06-05)

Initial release.
