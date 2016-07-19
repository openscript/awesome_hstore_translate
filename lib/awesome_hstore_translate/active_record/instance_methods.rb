module AwesomeHstoreTranslate
  module ActiveRecord
    module InstanceMethods
      def read_translated_attribute(attr, locale = I18n.locale)
        locales = []
        locales << locale
        locales += get_fallback_for_locale(locale) if translation_options[:fallbacks]
        translations = read_attribute(attr)

        locales.uniq.each do |cur|
          if translations.has_key?(cur.to_s)
            return translations[cur.to_s]
          end
        end

        nil
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

      protected

      def get_fallback_for_locale(locale)
        I18n.fallbacks[locale] if I18n.respond_to?(:fallbacks)
      end
    end
  end
end