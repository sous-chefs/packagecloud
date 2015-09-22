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
  base_url = new_resource.base_url
  repo_url = construct_uri_with_options(base_url: base_url, repo: new_resource.repository, endpoint: node['platform'])

  Chef::Log.debug("#{new_resource.name} deb repo url = #{repo_url}")

  package 'apt-transport-https'

  template "/etc/apt/sources.list.d/#{filename}.list" do
    source 'apt.erb'
    cookbook 'packagecloud'
    mode '0644'
    variables :base_url     => read_token(repo_url).to_s,
              :distribution => node['lsb']['codename'],
              :component    => 'main'

    notifies :run, "execute[apt-key-add-#{filename}]", :immediately
    notifies :run, "execute[apt-get-update-#{filename}]", :immediately
  end

  gpg_key_url = ::File.join(base_url, node['packagecloud']['gpg_key_path'])

  execute "apt-key-add-#{filename}" do
    command "wget -qO - #{gpg_key_url} | apt-key add -"
    action :nothing
  end

  execute "apt-get-update-#{filename}" do
    command "apt-get update -o Dir::Etc::sourcelist=\"sources.list.d/#{filename}.list\"" \
            " -o Dir::Etc::sourceparts=\"-\"" \
            " -o APT::Get::List-Cleanup=\"0\""
    action :nothing
  end
end

def install_rpm
  given_base_url = new_resource.base_url

  base_repo_url = ::File.join(given_base_url, node['packagecloud']['base_repo_path'])

  base_url_endpoint = construct_uri_with_options({base_url: base_repo_url, repo: new_resource.repository, endpoint: 'rpm_base_url'})

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
      template = run_context.resource_collection.find(template: "/etc/yum.repos.d/#{filename}.repo")
      template.variables[:repo_gpgcheck] = 0
    end
    not_if 'rpm -qa | grep -qw pygpgme'
  end

  yum_repository filename do
    baseurl read_token(base_url).to_s
    repo_gpgcheck true
    description filename
    metadata_expire new_resource.metadata_expire
    gpgkey ::File.join(given_base_url, node['packagecloud']['gpg_key_path'])
    gpgcheck false
  end
end

def install_gem
  base_url = new_resource.base_url

  repo_url = construct_uri_with_options(base_url: base_url, repo: new_resource.repository)
  repo_url = read_token(repo_url, true).to_s

  execute "install packagecloud #{new_resource.name} repo as gem source" do
    command "gem source --add #{repo_url}"
    not_if "gem source --list | grep #{repo_url}"
  end
end

def read_token(repo_url, gems=false)
  return repo_url unless new_resource.master_token

  base_url = new_resource.base_url

  base_repo_url = ::File.join(base_url, node['packagecloud']['base_repo_path'])

  uri = construct_uri_with_options(base_url: base_repo_url, repo: new_resource.repository, endpoint: 'tokens.text')
  uri.user     = new_resource.master_token
  uri.password = ''

  resp = post(uri, install_endpoint_params)

  Chef::Log.debug("#{new_resource.name} TOKEN = #{resp.body.chomp}")

  if is_rhel5? && !gems
    repo_url
  else
    repo_url.user     = resp.body.chomp
    repo_url.password = ''
    repo_url
  end
end

def install_endpoint_params
  dist = value_for_platform_family(
    'debian' => node['lsb']['codename'],
    ['rhel', 'fedora'] => node['platform_version'],
  )

  hostname = node['packagecloud']['hostname_override'] ||
             node['fqdn'] ||
             node['hostname']

  if !hostname
    raise("Can't determine hostname!  Set node['packagecloud']['hostname_override'] " \
          "if it cannot be automatically determined by Ohai.")
  end

  { :os   => node['platform'],
    :dist => dist,
    :name => hostname }
end

def filename
  new_resource.name.gsub(/[^0-9A-z.\-]/, '_')
end

def is_rhel5?
  platform_family?('rhel') && node['platform_version'].to_i == 5
end

def construct_uri_with_options(options)
  required_options = [:base_url, :repo]

  required_options.each do |opt|
    if !options[opt]
      raise ArgumentError,
            "A required option :#{opt} was not specified"
    end
  end

  options[:base_url] = append_trailing_slash(options[:base_url])
  options[:repo]     = append_trailing_slash(options[:repo])

  URI.join(options.delete(:base_url), options.inject([]) {|mem, opt| mem << opt[1]}.join)
end

def append_trailing_slash(str)
  str.end_with?("/") ? str : str + "/"
end
