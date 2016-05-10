module Wowza
  module REST
    class Server

      attr_reader :uri

      def initialize(host:, port:)
        @uri = URI("http://#{host}:#{port}")
      end

      def connect(username:, password:)
        auth = Authentication.new(username, password)
        conn = Connection.new(uri, auth)
        Client.new(conn)
      end

    end
  end
end
