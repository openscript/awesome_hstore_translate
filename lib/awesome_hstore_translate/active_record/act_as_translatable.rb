module AwesomeHstoreTranslate
  module ActiveRecord
    module ActAsTranslatable
      def translates(*attr_names)
        options = attr_names.extract_options!

        bootstrap(options)

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

        class_attribute :options
        self.options = options
      end

      def bootstrap(options)
        apply_options(options)

        include InstanceMethods
        extend ClassMethods
      end
    end
  end
end