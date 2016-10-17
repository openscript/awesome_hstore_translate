module AwesomeHstoreTranslate
  module ActiveRecord
    module Core
      module ClassMethods
        def find_by(*args)
          attrs = args.first
          if attrs.is_a?(Hash) && contains_translated_attributes(attrs)
            where(attrs).limit(1).first
          else
            super
          end
        end

        private

        def contains_translated_attributes(attrs)
          !(self.translated_attribute_names & attrs.keys).empty?
        end
      end
    end
  end
end