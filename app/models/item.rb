class Item < ActiveRecord::Base
  has_many :characters
  has_many :tiles
end
