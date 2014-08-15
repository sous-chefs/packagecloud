include ::PackageCloud::Helper

require 'uri'

use_inline_resources if defined?(use_inline_resources)

action :add do
  case new_resource.type
  when 'deb'
    install_deb
  when 'rpm'
    install_rpm
  when 'gem'
    install_gem
  else
    raise "#{new_resource.type} is an unknown package type."
  end
end

def install_deb
  repo_url = URI.join(node['packagecloud']['base_repo_url'], new_resource.repository + '/', node['platform'])

  Chef::Log.debug("#{new_resource.name} deb repo url = #{repo_url}")

  package 'apt-transport-https'

  apt_repository filename do
    uri read_token(repo_url).to_s
    deb_src true
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'pgp.mit.edu'
    key 'D59097AB'
  end
end

def install_rpm
  base_url_endpoint = URI.join(node['packagecloud']['base_url'], new_resource.repository + '/', 'rpm_base_url')

  if new_resource.master_token
    base_url_endpoint.user     = new_resource.master_token
    base_url_endpoint.password = ''
  end

  base_url = URI(get(base_url_endpoint, install_endpoint_params).body.chomp)

  Chef::Log.debug("#{new_resource.name} rpm base url = #{base_url}")

  package 'pygpgme' do
    ignore_failure true
  end

  log 'pygpgme_warning' do
    message 'The pygpgme package could not be installed. This means GPG verification is not possible for any RPM installed on your system. ' \
            'To fix this, add a repository with pygpgme. Usualy, the EPEL repository for your system will have this. ' \
            'More information: https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F and https://github.com/opscode-cookbooks/yum-epel'

    level :warn
    not_if 'rpm -qa | grep -qw pygpgme'
  end

  ruby_block 'disable repo_gpgcheck if no pygpgme' do
    block do
      template = run_context.resource_collection.find(:template => "/etc/yum.repos.d/#{filename}.repo")
      template.variables[:repo_gpgcheck] = 0
    end
    not_if 'rpm -qa | grep -qw pygpgme'
  end

  remote_file '/etc/pki/rpm-gpg/RPM-GPG-KEY-packagecloud' do
    source URI.join(node['packagecloud']['base_repo_url'], 'gpg.key').to_s
    mode '0644'
  end

  template "/etc/yum.repos.d/#{filename}.repo" do
    source 'yum.erb'
    cookbook 'packagecloud'
    mode '0644'
    variables :base_url      => read_token(base_url).to_s,
              :name          => filename,
              :repo_gpgcheck => 1,
              :description   => "#{node['packagecloud']['base_repo_url']}/#{filename}"
    notifies :run, "execute[yum-makecache-#{filename}]", :immediately
    notifies :create, "ruby_block[yum-cache-reload-#{filename}]", :immediately
  end

  # get the metadata for this repo only
  execute "yum-makecache-#{filename}" do
    command "yum -q makecache -y --disablerepo=* --enablerepo=#{filename}"
    action :nothing
  end

  # reload internal Chef yum cache
  ruby_block "yum-cache-reload-#{filename}" do
    block { Chef::Provider::Package::Yum::YumCache.instance.reload }
    action :nothing
  end
end

def install_gem
  repo_url = URI.join(node['packagecloud']['base_repo_url'], new_resource.repository + '/')

  read_token(repo_url)

  execute "install packagecloud #{new_resource.name} repo as gem source" do
    command "gem source --add #{repo_url}"
    not_if "gem source --list | grep #{repo_url}"
  end
end

def read_token(repo_url)
  return repo_url unless new_resource.master_token

  uri = URI.join(node['packagecloud']['base_url'], new_resource.repository + '/', 'tokens.text')
  uri.user     = new_resource.master_token
  uri.password = ''

  resp = post(uri, install_endpoint_params)

  Chef::Log.debug("#{new_resource.name} TOKEN = #{resp.body.chomp}")

  repo_url.user     = resp.body.chomp
  repo_url.password = ''
  repo_url
end

def install_endpoint_params
  dist = value_for_platform_family(
    'debian' => node['lsb']['codename'],
    ['rhel', 'fedora'] => node['platform_version'],
  )

  { :os   => node['platform'],
    :dist => dist,
    :name => node['fqdn'] }
end

def filename
  new_resource.name.gsub(/[^0-9A-z.\-]/, '_')
end
