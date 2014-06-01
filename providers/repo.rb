require "net/https"

BASE_URL = "https://packagecloud.io/install/repositories/"

action :add do
  case new_resource.type
  when "deb"
    install_deb
  when "rpm"
    install_rpm
  else
    raise "Unimplemented."
  end
end

def install_deb
  name = new_resource.name
  filename = name.sub("/", "_")

  package "apt-transport-https"

  if new_resource.master_token
    uri = URI(BASE_URL + "#{name}/tokens.text")
    uri.user     = new_resource.master_token
    uri.password = ""

    resp = post uri, :os   => node[:platform],
                     :dist => node['lsb']['codename'],
                     :name => node[:fqdn]

    url = "https://#{resp.body.chomp}:@packagecloud.io/#{name}/#{node[:platform]}/"
  else
    url = "https://packagecloud.io/#{name}/#{node[:platform]}/"
  end

  apt_repository filename do
    uri          url
    distribution node["lsb"]["codename"]
    components   ["main"]
    keyserver    "pgp.mit.edu"
    key          "D59097AB"
  end
end

def install_rpm
  name = new_resource.name
  filename = name.sub("/", "_")

  params = {:os   => node[:platform],
            :dist => node[:platform_version],
            :name => node[:fqdn]}

  base_url_endpoint = URI(BASE_URL + "#{name}/rpm_base_url")
  if new_resource.master_token
    base_url_endpoint.user     = new_resource.master_token
    base_url_endpoint.password = ""
  end

  base_url = URI(get(base_url_endpoint, params).body.chomp)

  if new_resource.master_token
    uri = URI(BASE_URL + "#{name}/tokens.text")
    uri.user     = new_resource.master_token
    uri.password = ""

    resp = post(uri, params)

    base_url.user     = resp.body.chomp
    base_url.password = ""
  end

  yum_repository filename do
    baseurl   base_url.to_s
    sslverify true
    gpgkey    "https://packagecloud.io/gpg.key"
    gpgcheck  false
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
