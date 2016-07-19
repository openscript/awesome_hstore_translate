require 'active_record'

class PageWithFallbacks < ActiveRecord::Base
  translates :title, accessors: [:en, :de]
end