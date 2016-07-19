module AwesomeHstoreTranslate
  module ActiveRecord
    module Attributes
      protected

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