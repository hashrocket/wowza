module Wowza
  module WillChange

    def self.included(host)
      def host.track_changes(*attrs)
        attrs.each { |attr| track_change(attr) }
      end

      def host.track_change(attr)
        define_method(:will_change!) do |attr|
          attribute_will_change!(attr)
        end
      end
    end

    def changed?
      !changed_attributes.empty?
    end

    def changed
      changed_attributes.keys
    end

    def changes
      Hash[changed.map { |attr| [attr, attribute_change(attr)] }]
    end

    def changed_attributes
      @changed_attributes ||= {}
    end

    def restore_attributes(attributes = changed)
      attributes.each { |attr| restore_attribute! attr }
    end

    private

    def changes_include?(attr_name)
      changed_attributes.include?(attr_name)
    end

    def changes_applied
      clear_changes_information
    end

    def clear_changes_information
      @changed_attributes = {}
    end

    def attribute_change(attr)
      [changed_attributes[attr], send(attr)] if attribute_changed?(attr)
    end

    def attribute_previous_change(attr)
      previous_changes[attr] if attribute_previously_changed?(attr)
    end

    def attribute_will_change!(attr)
      return if attribute_changed?(attr)

      begin
        value = __send__(attr)
        value = value.duplicable? ? value.clone : value
      rescue TypeError, NoMethodError
      end

      set_attribute_was(attr, value)
    end

    def restore_attribute!(attr)
      if attribute_changed?(attr)
        send("#{attr}=", changed_attributes[attr])
        clear_attribute_changes([attr])
      end
    end

    def attribute_changed?(attr)
      changes_include?(attr)
    end

    def set_attribute_was(attr, old_value)
      changed_attributes[attr] = old_value
    end

    def clear_attribute_changes(attributes)
      changed_attributes.except!(*attributes)
    end
  end
end
