require 'active_record'
require 'awesome_hstore_translate/version'

module AwesomeHstoreTranslate
  autoload :ActiveRecord, 'awesome_hstore_translate/active_record'
end

ActiveRecord::Base.extend(AwesomeHstoreTranslate::ActiveRecord::ActAsTranslatable)
