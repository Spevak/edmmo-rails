class Character < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :tile

  def move_to(x, y)
    if (self.x - x).abs <= 1 and (self.y - y).abs <= 1 then
      self.tile = Tile.tile_at(x, y)
    end
  end

  def pick_up(item_id)
    i = Item.find_by_id(item_id)
  end

  def use_item(x, y)
  end
end
