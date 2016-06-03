module Wowza
  module REST
    class Publisher

      include Assignment::Attributes
      include Wowza::WillChange

      attr_accessor :name, :password, :server_name, :persisted, :conn
      track_changes :name, :password, :server_name

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
        self.persisted = false
        changes_applied
      end

      def attributes
        {
          name: name,
          password: password,
        }
      end

      def to_json
        attributes.to_json
      end

      def id
        if changes[:name].nil?
          name
        else
          changes[:name].first
        end
      end

      def save
        resp = conn.send(persist_method) do |req|
          req.url persist_path
          req.body = to_json
        end
        if resp.status == 201 || resp.status == 200
          self.persisted = true
        end
        changes_applied
      end

      def persisted=(persisted)
        @persisted = persisted
        if persisted
          changes_applied
        end
      end

      def persisted?
        persisted
      end

      def name=(newName)
        will_change! :name unless newName == @name
        @name = newName
      end

      def password=(newPassword)
        will_change! :password unless newPassword == @password
        @password = newPassword
      end

      def reload!
        resp = conn.get resource_path
        attributes = JSON.parse(resp.body)
        assign_attributes(attributes) if attributes
        clear_changes_information
      end

      def rollback!
        restore_attributes
      end

      def destroy
        if persisted?
          resp = conn.delete resource_path
          if resp.status == 204
            self.persisted = false
            clear_changes_information
          end
        end
      end

      def server_name
        @server_name || "_defaultServer_"
      end

      private

      def persist_method
        persisted? ? :put : :post
      end

      def resource_path
        "#{server_path}/publishers/#{id}"
      end

      def resources_path
        "#{server_path}/publishers"
      end

      def persist_path
        persisted? ? resource_path : resources_path
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

    end
  end
end
