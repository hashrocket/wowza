module Wowza
  module REST
    class Stream

      include Assignment::Attributes

      attr_accessor :name, :is_connected, :is_recording, :source_ip,
        :server_name, :app_id, :vhost_name, :instance_name, :conn

      def self.deserialize(attrs)
        attrs = attrs.with_indifferent_access
        {
          name: attrs["name"],
          is_connected: attrs["isConnected"],
          is_recording: attrs["isRecordingSet"],
          source_ip: attrs["sourceIp"],
        }
      end

      def self.find_by(attrs)
        new(attrs).reload!
      end

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

      def is_connected
        @is_connected || false
      end

      def connected?
        is_connected
      end

      def is_recording
        @is_recording || false
      end

      def recording?
        is_recording
      end

      def reload!
        resp = conn.get resource_path
        attrs = JSON.parse(resp.body)
        assign_attributes(self.class.deserialize(attrs)) if attrs
        self
      end

      def name=(name)
        unless name.nil?
          @name = name
        end
      end

      def resource_path
        "#{instance_path}/incomingstreams/#{id}"
      end

      def server_name
        @server_name || "_defaultServer_"
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

      def vhost_name
        @vhost_name || "_defaultVHost_"
      end

      def vhost_path
        "#{server_path}/vhosts/#{vhost_name}"
      end

      def app_id
        @app_id || 'live'
      end

      def application_path
        "#{vhost_path}/applications/#{app_id}"
      end

      def instance_name
        @instance_name || "_definst_"
      end

      def instance_path
        "#{application_path}/instances/#{instance_name}"
      end

      def id
        name
      end

    end
  end
end
