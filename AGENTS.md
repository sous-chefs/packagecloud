# Agent Notes

## Package Availability

This cookbook configures packagecloud.io repositories. It does not install
packagecloud.io itself and does not build packages.

packagecloud.io documents repository support for RPM, DEB, Debian source,
RubyGems, Python, Node.js, Alpine, Maven, Helm, and generic files. The
`packagecloud_repo` resource manages only APT/DEB, YUM/DNF/RPM, and RubyGems
repository sources.

### APT (Debian/Ubuntu)

* packagecloud supports DEB repositories, including `any/any` repositories for
  packages that work across Debian-based distributions.
* This cookbook tests Debian 12 and Ubuntu 22.04/24.04.
* EOL Debian and Ubuntu releases were removed from the supported platform and
  Kitchen matrices.

### DNF/YUM (RHEL family)

* packagecloud supports RPM repositories, including `rpm_any/rpm_any`
  repositories for packages that work across RPM-based distributions.
* This cookbook tests AlmaLinux 8/9, Amazon Linux 2023, CentOS Stream 9,
  Fedora latest, Oracle Linux 8/9, and Rocky Linux 8/9.
* EOL CentOS Linux 7, CentOS Stream 8, Oracle Linux 7, and Scientific Linux were
  removed from the supported platform and Kitchen matrices.

### Zypper (SUSE)

* The existing resource does not implement SUSE/Zypper repository management.
  openSUSE Leap was removed from Kitchen because the resource type default only
  maps Debian, RHEL, Fedora, and Amazon platform families.

## Architecture Limitations

Architecture availability is determined by the packages uploaded to each
packagecloud repository. The cookbook writes repository configuration and does
not constrain package architectures.

## Source/Compiled Installation

No source or compiled installation path is managed by this cookbook.

## Known Issues

* Private RubyGems repository removal can only remove sources that can be
  matched from the configured packagecloud repository URL; packagecloud read
  tokens may differ between runs.
* APT repository installation still uses the legacy `apt-key` command because
  that is the behavior exposed by the existing resource and packagecloud
  repository install flow.

## Policyfile Migration Notes

* Dependency resolution is managed by `Policyfile.rb`; do not reintroduce
  legacy dependency files.
* Test Kitchen suites use Policyfile named run lists. Keep `Policyfile.rb`,
  Kitchen suite names, and CI matrix suite names aligned when adding suites.
