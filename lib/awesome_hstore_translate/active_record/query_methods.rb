module AwesomeHstoreTranslate
  module ActiveRecord
    module QueryMethods
      def where(opts = :chain, *rest)
        if opts.is_a?(Hash)
          translated_attrs = translated_attributes(opts)
          normal_attrs = opts.reject{ |key, _| translated_attrs.include? key}
          query = spawn
          query.where!(normal_attrs, *rest) unless normal_attrs.empty?

          translated_attrs.each do |attribute|
            if opts[attribute].is_a?(String)
              query.where!(":key = any(avals(#{attribute}))", key: opts[attribute])
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
      end
    end
  end
end