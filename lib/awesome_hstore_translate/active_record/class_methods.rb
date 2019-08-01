module AwesomeHstoreTranslate
  module ActiveRecord
    module ClassMethods
      def translates?
        included_modules.include?(InstanceMethods)
      end

      def without_fallbacks(&block)
        before_state = translation_options[:fallbacks]
        toggle_fallback if translation_options[:fallbacks]
        yield block
        translation_options[:fallbacks] = before_state
      end

      def with_fallbacks(&block)
        before_state = translation_options[:fallbacks]
        toggle_fallback unless translation_options[:fallbacks]
        yield block
        translation_options[:fallbacks] = before_state
      end

      def get_column_name(attr)
        column_name = attr.to_s
        # detect column from original hstore_translate
        column_name << '_translations' if !has_attribute?(column_name) && has_attribute?("#{column_name}_translations")

        column_name
      end

      protected

      def toggle_fallback
        translation_options[:fallbacks] = !translation_options[:fallbacks]
      end

      private

      # Override the default relation methods in order to inject custom finder methods for hstore translations.
      def relation
        super.extending!(QueryMethods)
      end
    end
  end
end