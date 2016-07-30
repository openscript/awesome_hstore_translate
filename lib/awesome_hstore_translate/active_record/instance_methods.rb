module AwesomeHstoreTranslate
  module ActiveRecord
    module InstanceMethods
      protected

      def read_translated_attribute(attr, locale = I18n.locale)
        locales = []
        locales << locale
        locales += get_fallback_for_locale(locale) || [] if translation_options[:fallbacks]

        translations = read_raw_attribute(attr)

        if translations
          locales.uniq.each do |cur|
            if translations.has_key?(cur.to_s) && !translations[cur.to_s].empty?
              return translations[cur.to_s]
            end
          end
        end

        nil
      end

      def read_raw_attribute(attr)
        read_attribute(get_column_name(attr))
      end

      def write_translated_attribute(attr, value, locale= I18n.locale)
        translations = read_raw_attribute(attr) || {}
        translations[locale] = value
        write_raw_attribute(attr, translations)
      end

      def write_raw_attribute(attr, value)
        write_attribute(get_column_name(attr), value)
      end

      def get_fallback_for_locale(locale)
        I18n.fallbacks[locale] if I18n.respond_to?(:fallbacks)
      end

      private

      def get_column_name(attr)
        column_name = attr.to_s
        # detect column from original hstore_translate
        column_name << '_translations' if !has_attribute?(column_name) && has_attribute?("#{column_name}_translations")

        column_name
      end
    end
  end
end