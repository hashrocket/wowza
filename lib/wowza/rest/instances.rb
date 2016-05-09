module Wowza
  module REST
    class Instances

      attr_reader :application

      def initialize(conn, application)
        @conn = conn
        @application = application
      end

      def all
        resp = conn.get("#{application.href}/instances")
        JSON.parse(resp.body)['instanceList'].map do |attrs|
          Instance.new({
            name: attrs["name"]
          })
        end
      end

      private

      attr_reader :conn
    end
  end
end
