class Character < ActiveRecord::Base
  has_one :item
  belongs_to :user

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
