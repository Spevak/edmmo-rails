class Tile < ActiveRecord::Base
  belongs_to :item_id
  belongs_to :character_id
end
