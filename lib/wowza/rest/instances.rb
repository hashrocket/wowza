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
            Stream.new({
              name: stream["name"],
              is_connected: stream["isConnected"],
              is_recording: stream["isRecordingSet"],
              source_ip: stream["sourceIp"],
            })
          end
          instance
        end
      end

      private

      attr_reader :conn, :application
    end
  end
end
