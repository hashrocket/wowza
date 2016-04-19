module Wowza
  module REST
    class Server

      attr_reader :uri

      def initialize(host:, port:, server:)
        @uri = URI("http://#{host}:#{port}/v2/servers/#{server}")
      end

      def connect(username:, password:)
        auth = Authentication.new(username, password)
        conn = Connection.new(uri, auth)
        Client.new(conn)
      end

    end
  end
end
