module AwesomeHstoreTranslate
  module ActiveRecord
    module ClassMethods
      def translates?
        included_modules.include?(InstanceMethods)
      end

      def without_fallbacks(&block)
        before_state = options[:fallbacks]
        toggle_fallback if options[:fallbacks]
        yield block
        options[:fallbacks] = before_state
      end

      def with_fallbacks(&block)
        before_state = options[:fallbacks]
        toggle_fallback unless options[:fallbacks]
        yield block
        options[:fallbacks] = before_state
      end

      protected

      def toggle_fallback
        options[:fallbacks] = !options[:fallbacks]
      end

      def define_attributes(attr)
        define_reader_attribute(attr)
        define_writer_attribute(attr)
        define_raw_reader_attribute(attr)
        define_raw_writer_attribute(attr)
      end

      def define_reader_attribute(attr)
        define_method(attr) do
          read_translated_attribute(attr)
        end
      end

      def define_raw_reader_attribute(attr)
        define_method(:"#{attr}_raw") do
          read_raw_attribute(attr)
        end
      end

      def define_writer_attribute(attr)
        define_method(:"#{attr}=") do |value|
          write_translated_attribute(attr, value)
        end
      end

      def define_raw_writer_attribute(attr)
        define_method(:"#{attr}_raw=") do |value|
          write_raw_attribute(attr, value)
        end
      end
    end
  end
end