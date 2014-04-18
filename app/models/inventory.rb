class Inventory < ActiveRecord::Base
  has_many :items
  has_one :character
end
