module AwesomeHstoreTranslate
  module ActiveRecord
    module QueryMethods
      class WhereChain < ::ActiveRecord::QueryMethods::WhereChain
      end

      def where(opts = :chain, *rest)
        if opts == :chain
          WhereChain.new(spawn)
        elsif opts.blank?
          return self
        elsif opts.is_a?(Hash)
          translated_attrs = translated_attributes(opts)
          normal_attrs = opts.reject{ |key, _| translated_attrs.include? key}
          query = spawn
          query.where!(normal_attrs) unless normal_attrs.empty?

          translated_attrs.each do |attribute|
            if opts[attribute].is_a?(String)
              query.where!("'#{opts[attribute]}' = any(avals(#{attribute}))")
            else
              super(opts, rest)
            end
          end
          return query
        end
        super(opts, rest)
      end

      private

      def translated_attributes(opts)
        self.translated_attribute_names & opts.keys
      end
    end
  end
end