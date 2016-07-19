require 'active_record'

class PageWithoutFallbacks < ActiveRecord::Base
  translates :title, fallbacks: false
end