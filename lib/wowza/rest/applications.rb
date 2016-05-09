module Wowza
  module REST
    class Applications

      def initialize(conn)
        @conn = conn
      end

      def all
        resp = conn.get('/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications')
        JSON.parse(resp.body)['applications'].map do |attrs|
          Application.new({
            id: attrs["id"],
            href: attrs["href"],
            app_type: attrs["appType"],
            dvr_enabled: attrs["dvrEnabled"],
            drm_enabled: attrs["drmEnabled"],
            transcoder_enabled: attrs["transcoderEnabled"],
            stream_targets_enabled: attrs["streamTargetsEnabled"],
          }).tap do |app|
            app.conn = conn
          end
        end
      end

      private

      attr_reader :conn
    end
  end
end
