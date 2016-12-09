module AwesomeHstoreTranslate
  module ActiveRecord
    module QueryMethods
      def where(opts = :chain, *rest)
        if opts.is_a?(Hash)
          query = spawn
          translated_attrs = translated_attributes(opts)
          untranslated_attrs = untranslated_attributes(opts)

          unless untranslated_attrs.empty?
            query.where!(untranslated_attrs, *rest)
          end

          translated_attrs.each do |key, value|
            if value.is_a?(String)
              query.where!(":value = any(avals(#{key}))", value: value)
            else
              super
            end
          end
          query
        else
          super
        end
      end

      private

      def translated_attributes(opts)
        self.translated_attribute_names & opts.keys
        opts.select{ |key, _| self.translated_attribute_names.include? key }
      end

      def untranslated_attributes(opts)
        opts.reject{ |key, _| self.translated_attribute_names.include? key }
      end
    end
  end
end