module Wowza
  module REST
    class Client

      attr_reader :connection

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
        StatusParser.new.parse(get_json('status'))
      end

      private

      def get_json(path)
        JSON.parse(connection.get(path).body)
      end

    end
  end
end
