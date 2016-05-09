module Wowza
  module REST
    class Instances

      def initialize(conn, application)
        @conn = conn
        @application = application
      end

      def all
        resp = conn.get("#{application.href}/instances")
        JSON.parse(resp.body)['instanceList'].map do |attrs|
          instance = Instance.new({
            name: attrs["name"]
          })
          streams = attrs.fetch("incomingStreams", [])
          instance.incoming_streams = streams.map do |stream|
            attrs = Stream.deserialize(stream)
            Stream.new(attrs.merge({ conn: conn }))
          end
          instance
        end
      end

      private

      attr_reader :conn, :application
    end
  end
end
