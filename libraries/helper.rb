module PackageCloud
  module Helper
    require 'net/https'

    def get(uri, params)
      uri.query     = URI.encode_www_form(params)
      req           = Net::HTTP::Get.new(uri.request_uri)

      req.basic_auth uri.user, uri.password if uri.user

      proxy = node['packagecloud'].values_at('proxy_host', 'proxy_port')
      http = Net::HTTP.new(uri.hostname, uri.port, *(proxy if proxy.first))
      http.use_ssl = true

      resp = http.start { |h| h.request(req) }

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

      proxy = node['packagecloud'].values_at('proxy_host', 'proxy_port')
      http = Net::HTTP.new(uri.hostname, uri.port, *(proxy if proxy.first))
      http.use_ssl = true

      resp = http.start { |h| h.request(req) }

      case resp
      when Net::HTTPSuccess
        resp
      else
        raise resp.inspect
      end
    end
  end
end
