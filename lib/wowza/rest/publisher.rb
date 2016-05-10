module Wowza
  module REST
    class Publisher

      include ActiveModel::AttributeAssignment
      include ActiveModel::Serializers::JSON
      include ActiveModel::Dirty

      attr_accessor :name, :password, :server_name, :persisted, :conn
      define_attribute_methods :name, :password, :server_name

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
          server_name: server_name
        }
      end

      def id
        if changes["name"].present?
          changes["name"].first
        else
          name
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

      def attrs
        {
          name: name,
          password: password
        }
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
        name_will_change! unless newName == @name
        @name = newName
      end

      def password=(newPassword)
        password_will_change! unless newPassword == @password
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

      def server_name
        @server_name || "_defaultServer_"
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

    end
  end
end
