module Wowza
  module REST
    class Publishers

      def initialize(conn)
        @conn = conn
      end

      def all
        resp = conn.get('publishers')
        JSON.parse(resp.body)['publishers'].map do |attrs|
          Publisher.new(name: attrs["name"]).tap do |p|
            p.conn = conn
            p.persisted = true
          end
        end
      end

      private

      attr_reader :conn
    end
  end
end
