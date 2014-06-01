require "net/https"

BASE_URL = "https://packagecloud.io/install/repositories/"

action :add do
  case new_resource.type
  when "deb"
    install_deb
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
