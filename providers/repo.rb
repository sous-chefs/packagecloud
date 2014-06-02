require "net/https"

BASE_REPO_URL = "https://packagecloud.io/"
BASE_URL = "https://packagecloud.io/install/repositories/"

action :add do
  case new_resource.type
  when "deb"
    install_deb
  when "rpm"
    install_rpm
  when "gem"
    install_gem
  else
    raise "#{new_resource.type} is an unknown package type."
  end
end

def install_endpoint_params(dist)
  {:os   => node[:platform],
   :dist => dist,
   :name => node[:fqdn]}
end

def set_read_token(repo_url, dist)
  if new_resource.master_token
    uri = URI(BASE_URL + "#{new_resource.name}/tokens.text")
    uri.user     = new_resource.master_token
    uri.password = ""

    resp = post(uri, install_endpoint_params(dist))

    repo_url.user     = resp.body.chomp
    repo_url.password = ""
  end
end

def install_deb
  name     = new_resource.name
  filename = name.sub("/", "_")
  repo_url = URI("#{BASE_REPO_URL}/#{name}/#{node[:platform]}/")

  package "apt-transport-https"

  set_read_token(repo_url, node['lsb']['codename'])

  apt_repository filename do
    uri          repo_url.to_s
    distribution node["lsb"]["codename"]
    components   ["main"]
    keyserver    "pgp.mit.edu"
    key          "D59097AB"
  end
end

def rpm_base_url(dist)
  base_url_endpoint = URI(BASE_URL + "#{new_resource.name}/rpm_base_url")

  if new_resource.master_token
    base_url_endpoint.user     = new_resource.master_token
    base_url_endpoint.password = ""
  end

  URI(get(base_url_endpoint, install_endpoint_params(dist)).body.chomp)
end

def install_rpm
  name     = new_resource.name
  filename = name.sub("/", "_")
  dist     = node[:platform_version]
  base_url = rpm_base_url(dist)

  set_read_token(base_url, dist)

  yum_repository filename do
    description "https://packagecloud.io/#{name}"
    baseurl     base_url.to_s
    sslverify   true
    gpgkey      "https://packagecloud.io/gpg.key"
    gpgcheck    false
  end
end

def install_gem
  name     = new_resource.name
  repo_url = URI("https://packagecloud.io/#{name}/")

  set_read_token(repo_url, nil)

  execute "install packagecloud #{name} repo as gem source" do
    command "gem source --add #{repo_url.to_s}"
    not_if "gem source --list | grep #{repo_url.to_s}"
  end
end

def post(uri, params)
  req           = Net::HTTP::Post.new(uri.request_uri)
  req.form_data = params

  req.basic_auth uri.user, uri.password if uri.user

  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true

  resp = http.start {|http|
    http.request(req)
  }

  case resp
  when Net::HTTPSuccess
    resp
  else
    raise resp.inspect
  end
end

def get(uri, params)
  uri.query     = URI.encode_www_form(params)
  req           = Net::HTTP::Get.new(uri.request_uri)

  req.basic_auth uri.user, uri.password if uri.user

  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true

  resp = http.start {|http|
    http.request(req)
  }

  case resp
  when Net::HTTPSuccess
    resp
  else
    raise resp.inspect
  end
end
