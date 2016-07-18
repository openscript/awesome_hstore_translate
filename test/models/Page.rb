require 'active_record'

class Page < ActiveRecord::Base
  translates :title
end