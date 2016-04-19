module Wowza
  module REST
    class Publishers

      def initialize(conn)
        @conn = conn
      end

      def all
        resp = conn.get('publishers')
        JSON.parse(resp.body)['publishers'].map do |p|
          Publisher.new(p["name"])
        end
      end

      private

      attr_reader :conn
    end
  end
end
