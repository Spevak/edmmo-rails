class Character < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :tile

  def pick_up(item_id)
    self.item = Item.find_by_id(item_id)
  end

  def use_item(x, y)
    item_holding = self.item
    if item_holding
      item_holding.use(self.id, x, y)
    end
  end
end
