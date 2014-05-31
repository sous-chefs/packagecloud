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

    resp, data = Net::HTTP.post_form(uri, :os   => node[:platform],
                                          :dist => node['lsb']['codename'],
                                          :name => node[:fqdn])

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
