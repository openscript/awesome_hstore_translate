module AwesomeHstoreTranslate
  module ActiveRecord
    module Accessors
      protected

      def define_accessors(attr)
        translation_options[:accessors].each do |locale|
          define_reader_accessor(attr, locale)
          define_writer_accessor(attr, locale)
          self.translated_accessor_names << :"#{attr}_#{locale}"
        end
      end

      def define_reader_accessor(attr, locale)
        define_method get_accessor_name(attr, locale) do
          read_translated_attribute(attr, locale)
        end
      end

      def define_writer_accessor(attr, locale)
        define_method "#{get_accessor_name(attr, locale)}=" do |value|
          write_translated_attribute(attr, value, locale)
        end
      end

      def get_accessor_name(attr, locale)
        "#{attr}_#{locale.to_s.underscore}"
      end
    end
  end
end
