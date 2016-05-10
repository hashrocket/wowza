module Wowza
  module REST
    class Client

      attr_reader :server_name, :connection

      def initialize(connection)
        @connection = connection
      end

      def publishers
        Publishers.new(connection)
      end

      def applications
        Applications.new(connection)
      end

      def status
        StatusParser.new.parse(get_json(status_path))
      end

      def status_path
        "#{server_path}/status"
      end

      def server_name
        @server_name || "_defaultServer_"
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

      private

      def get_json(path)
        JSON.parse(connection.get(path).body)
      end

    end
  end
end
