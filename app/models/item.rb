class Item < ActiveRecord::Base
    belongs_to :character
    belongs_to :tile

    def use(character_id, x, y)
    end
end
