require 'net/https'

module PackageCloud
  module Helper
    def get(uri, params)
      uri.query = URI.encode_www_form(params)
      req       = Net::HTTP::Get.new(uri.request_uri)
      
      resp = http_request(req)
      
      case resp
      when Net::HTTPSuccess
        resp
      else
        raise resp.inspect
      end
    end

    def post(uri, params)
      req           = Net::HTTP::Post.new(uri.request_uri)
      req.form_data = params

      req.basic_auth uri.user, uri.password if uri.user
      
      resp = http_request(req)
      
      case resp
      when Net::HTTPSuccess
        resp
      else
        raise resp.inspect
      end
    end
    
    def http_request(request)
      if ENV['https_proxy'] || ENV['http_proxy']
        proxy_url = ENV['https_proxy'] || ENV['http_proxy']
        proxy_uri = URI.parse(proxy)
        proxy     = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)

        response = proxy.start(uri.host, :use_ssl => proxy_uri.scheme == 'https') do |http|
          http.request(request)
        end
      else
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true
  
        response = http.start { |h|  h.request(request) }
      end
      
      response
    end
  end
end
