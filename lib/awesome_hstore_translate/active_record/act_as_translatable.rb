module AwesomeHstoreTranslate
  module ActiveRecord
    module ActAsTranslatable
      def translates(*attrs)
        bootstrap

        enable_attributes(attrs) if attrs.present?
      end

      protected

      def enable_attributes(attrs)
        attrs.each do |attr|
          define_attributes(attr)
        end
      end

      def bootstrap
        include InstanceMethods
        extend ClassMethods
      end
    end
  end
end