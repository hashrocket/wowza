module Wowza
  module REST
    class Application

      include ActiveModel::AttributeAssignment

      attr_accessor :id, :href, :app_type, :dvr_enabled, :drm_enabled,
        :transcoder_enabled, :stream_targets_enabled, :conn

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

    end
  end
end
