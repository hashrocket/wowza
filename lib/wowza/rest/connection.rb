module Wowza
  module REST
    class Connection

      attr_reader :uri, :auth

      def initialize(uri, auth)
        @auth = auth
        @uri = uri
      end

      def get(path, query={}, &block)
        request_method(:get, path, query, &block)
      end

      def post(path, query={}, &block)
        request_method(:post, path, query, &block)
      end

      def put(path, query={}, &block)
        request_method(:put, path, query, &block)
      end

      def delete(path, query={}, &block)
        request_method(:delete, path, query, &block)
      end

      private

      def request_method(method, path, query, &block)
        full_uri = URI.join(uri, path)
        request(method, full_uri, query, &block)
      end

      def start(uri, &block)
        Net::HTTP.start( uri.host, uri.port,
          use_ssl: uri.scheme == 'https', &block)
      end

      REQUEST_TYPES = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        delete: Net::HTTP::Delete,
      }

      def request(method, uri, query)
        start(uri) do |http|
          req = REQUEST_TYPES[method].new uri, query
          req["Content-Type"] = "application/json"
          req["Accept"] = "application/json"
          yield(req) if block_given?
          res = http.request req
          if res.code == "401"
            auth = digest_auth(req, res)
            req["Authorization"] = auth
            http.request req
          else
            res
          end
        end
      end

      def digest_auth(req, res)
        uri = req.uri
        uri.user = auth.username
        uri.password = auth.password

        realm = res['www-authenticate']
        method = req.method.upcase
        Net::HTTP::DigestAuth.new.auth_header(uri, realm, method)
      end

    end
  end
end
