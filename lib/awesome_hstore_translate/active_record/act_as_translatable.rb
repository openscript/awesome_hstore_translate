module AwesomeHstoreTranslate
  module ActiveRecord
    module ActAsTranslatable
      def translates(*attr_names)
        options = attr_names.extract_options!

        bootstrap(options, attr_names)

        if attr_names.present?
          enable_attributes(attr_names)
          enable_accessors(attr_names) if options[:accessors]
        end
      end

      protected

      def enable_attributes(attr_names)
        extend Attributes
        attr_names.each do |attr_name|
          define_attributes(attr_name)
        end
      end

      def enable_accessors(attr_names)
        extend Accessors
        attr_names.each do |attr_name|
          define_accessors(attr_name)
        end
      end

      def apply_options(options)
        fallbacks = I18n.respond_to?(:fallbacks) ? I18n.fallbacks : true
        options[:fallbacks] = fallbacks unless options.include?(:fallbacks)
        options[:accessors] = false unless options.include?(:accessors)

        class_attribute :translation_options
        self.translation_options = options
      end

      def expose_translated_attrs(attr_names)
        class_attribute :translated_attribute_names
        self.translated_attribute_names = attr_names

        class_attribute :translated_accessor_names
        self.translated_accessor_names = []
      end

      def bootstrap(options, attr_names)
        apply_options(options)
        expose_translated_attrs(attr_names)

        include InstanceMethods
        extend Core::ClassMethods
        extend ClassMethods
      end
    end
  end
end
