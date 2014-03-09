class Character < ActiveRecord::Base
    has_one :Item
    belongs_to :User
         
    def pick_up(itemID)
        self.item_id = itemID
    end

    def use_item(x, y)
        item_holding = self.item
        if item_holding
            item_holding.use(self.id, x, y)
        end
    end
end
