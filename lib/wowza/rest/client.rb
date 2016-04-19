module Wowza
  module REST
    class Client

      attr_reader :connection

      def initialize(connection)
        @connection = connection
      end

      def publishers
        @_publishers ||= Publishers.new(connection)
      end

    end
  end
end
