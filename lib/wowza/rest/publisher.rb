module Wowza
  module REST
    class Publisher < Struct.new(:name, :password)
      attr_accessor :client

      def initialize(name:, password: nil)
        super(name, password)
        @_persisted = false
      end

      def save
        resp = client.connection.post do |req|
          req.url 'publishers'
          req.body = JSON.generate attrs
        end
        if resp.status == 201
          self.persisted = true
        end
      end

      def attrs
        {
          name: name,
          password: password
        }
      end

      def persisted?
        @_persisted
      end

      private

      def persist_method
        persisted? ? :put : :post
      end

      def persisted=(persisted)
        @_persisted = persisted
      end
    end
  end
end
