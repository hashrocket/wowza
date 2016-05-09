module Wowza
  module REST
    class Instance

      include ActiveModel::AttributeAssignment

      attr_accessor :name, :conn

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
      end

      def attributes
        {
          name: name
        }
      end

    end
  end
end
