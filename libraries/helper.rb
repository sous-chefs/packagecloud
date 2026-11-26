# frozen_string_literal: true

module PackageCloud
  module Helper
    require 'net/https'

    def get(uri, params)
      uri.query = URI.encode_www_form(params)
      req       = Net::HTTP::Get.new(uri.request_uri)

      req.basic_auth uri.user, uri.password if uri.user

      http = Net::HTTP.new(uri.hostname, uri.port, *proxy_options)
      http.use_ssl = true
      http.ca_file = system_ca_file if system_ca_file

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

      http = Net::HTTP.new(uri.hostname, uri.port, *proxy_options)
      http.use_ssl = true
      http.ca_file = system_ca_file if system_ca_file

      resp = http.start { |h| h.request(req) }

      case resp
      when Net::HTTPSuccess
        resp
      else
        raise resp.inspect
      end
    end

    def proxy_options
      return [] unless new_resource.proxy_host

      [new_resource.proxy_host, new_resource.proxy_port]
    end

    def system_ca_file
      %w(
        /etc/ssl/certs/ca-certificates.crt
        /etc/pki/tls/certs/ca-bundle.crt
      ).find { |path| ::File.exist?(path) }
    end
  end
end
