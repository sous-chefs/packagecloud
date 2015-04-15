require 'net/https'

module PackageCloud
  module Helper

    def get(uri, params)
      uri.query = URI.encode_www_form(params)
      req       = Net::HTTP::Get.new(uri.request_uri)

      http_request(uri, req)
    end

    def post(uri, params)
      req           = Net::HTTP::Post.new(uri.request_uri)
      req.form_data = params

      req.basic_auth uri.user, uri.password if uri.user

      http_request(uri, req)
    end

    def http_request(uri, request)
      if proxy_url = Chef::Config['https_proxy'] || Chef::Config['http_proxy'] || ENV['https_proxy'] || ENV['http_proxy']
        proxy_uri = URI.parse(proxy_url)
        proxy     = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)

        response = proxy.start(uri.host, :use_ssl => true) do |http|
          http.request(request)
        end
      else
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        response = http.start { |h|  h.request(request) }
      end

      raise response.inspect unless response.is_a? Net::HTTPSuccess
      response
    end

  end
end
