module AwesomeHstoreTranslate
  module ActiveRecord
    module InstanceMethods
      def read_translated_attribute(attr, locale = I18n.locale)
        read_attribute(attr)[locale.to_s]
      end

      def read_raw_attribute(attr)
        read_attribute(attr)
      end

      def write_translated_attribute(attr, value, locale= I18n.locale)
        translations = read_raw_attribute(attr) || {}
        translations[locale] = value
        write_raw_attribute(attr, translations)
      end

      def write_raw_attribute(attr, value)
        write_attribute(attr, value)
      end
    end
  end
end