module Wowza
  module REST
    class Stream

      include ActiveModel::AttributeAssignment

      attr_accessor :name, :is_connected, :is_recording, :source_ip, :conn

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
      end

      def attributes
        {
          name: name,
          is_connected: is_connected,
          is_recording: is_recording,
          source_ip: source_ip
        }
      end

      def connected?
        is_connected
      end

      def recording?
        is_recording
      end

    end
  end
end
