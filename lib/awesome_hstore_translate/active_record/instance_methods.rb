module AwesomeHstoreTranslate
  module ActiveRecord
    module InstanceMethods
      protected

      def read_translated_attribute(attr, locale = I18n.locale)
        locales = Array(locale)
        locales += get_fallback_for_locale(locale) || [] if translation_options[:fallbacks]

        translations = read_raw_attribute(attr)

        if translations
          locales.map(&:to_s).uniq.each do |cur|
            if translations.has_key?(cur) && !translations[cur].blank?
              return translations[cur]
            end
          end
        end

        nil
      end

      def read_raw_attribute(attr)
        read_attribute(self.class.get_column_name(attr))
      end

      def write_translated_attribute(attr, value, locale= I18n.locale)
        translations = read_raw_attribute(attr) || {}
        translations[locale] = value
        write_raw_attribute(attr, translations)
      end

      def write_raw_attribute(attr, value)
        write_attribute(self.class.get_column_name(attr), value)
      end

      def get_fallback_for_locale(locale)
        I18n.fallbacks[locale] if I18n.respond_to?(:fallbacks)
      end
    end
  end
end
