module Wowza
  module REST
    class Publishers

      attr_accessor :server_name

      def initialize(conn)
        @conn = conn
      end

      def all
        resp = conn.get(resource_path)
        JSON.parse(resp.body)['publishers'].map do |attrs|
          Publisher.new(name: attrs["name"]).tap do |p|
            p.conn = conn
            p.persisted = true
          end
        end
      end

      def find(name)
        resp = conn.get("#{resource_path}/#{name}")
        attrs = JSON.parse(resp.body)
        Publisher.new(name: attrs["name"]).tap do |p|
          p.conn = conn
          p.persisted = true
        end
      end

      def resource_path
        "#{server_path}/publishers"
      end

      def server_name
        @server_name || "_defaultServer_"
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

      private

      attr_reader :conn
    end
  end
end
