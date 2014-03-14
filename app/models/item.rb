class Item < ActiveRecord::Base
  has_one :character
  has_many :tiles
end
