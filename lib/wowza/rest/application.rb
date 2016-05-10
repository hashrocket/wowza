module Wowza
  module REST
    class Application

      include ActiveModel::AttributeAssignment

      attr_accessor :id, :href, :app_type, :dvr_enabled, :drm_enabled,
        :transcoder_enabled, :stream_targets_enabled,
        :server_name, :vhost_name, :conn

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
      end

      def attributes
        {
          id: id,
          href: href,
          app_type: app_type,
          dvr_enabled: dvr_enabled,
          drm_enabled: drm_enabled,
          transcoder_enabled: transcoder_enabled,
          stream_targets_enabled: stream_targets_enabled,
        }
      end

      def instances
        Instances.new(conn, self)
      end

      def href
        if !@href && resource_path
          resource_path
        else
          @href
        end
      end

      def resource_path
        id && "#{vhost_path}/applications/#{id}"
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

    end
  end
end
