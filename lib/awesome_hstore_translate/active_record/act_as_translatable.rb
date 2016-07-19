module AwesomeHstoreTranslate
  module ActiveRecord
    module ActAsTranslatable
      def translates(*attr_names)
        options = attr_names.extract_options!

        bootstrap(options, attr_names)

        enable_attributes(attr_names) if attr_names.present?
      end

      protected

      def enable_attributes(attr_names)
        attr_names.each do |attr_name|
          define_attributes(attr_name)
        end
      end

      def apply_options(options)
        options[:fallbacks] = true unless options.include?(:fallbacks)

        class_attribute :translation_options
        self.translation_options = options
      end

      def expose_translated_attrs(attr_names)
        class_attribute :translated_attribute_names
        self.translated_attribute_names = attr_names
      end

      def bootstrap(options, attr_names)
        apply_options(options)
        expose_translated_attrs(attr_names)

        include InstanceMethods
        extend ClassMethods
      end
    end
  end
end