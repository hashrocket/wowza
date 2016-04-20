module Wowza
  module REST
    class Connection
      extend Forwardable

      attr_reader :uri, :auth
      def_delegator :conn, :get
      def_delegator :conn, :post

      def initialize(uri, auth)
        @auth = auth
        @uri = uri
      end

      def conn
        @_conn ||= Faraday.new(uri).tap do |conn|
          conn.headers['Content-Type'] = 'application/json'
          conn.headers['Accept'] = 'application/json'
          conn.headers['Accept-Encoding'] = 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
          conn.request :digest, auth.username, auth.password
          conn.adapter  Faraday.default_adapter
        end
      end

    end
  end
end
