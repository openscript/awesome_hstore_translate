require 'active_record'

class PageWithFallbacks < ActiveRecord::Base
  translates :title
end