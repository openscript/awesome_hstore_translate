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

      protected

      def toggle_fallback
        translation_options[:fallbacks] = !translation_options[:fallbacks]
      end
    end
  end
end