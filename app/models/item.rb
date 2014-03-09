class Item < ActiveRecord::Base
    belongs_to :Character
    belongs_to :Tiles

    def use(character_id, x, y)
    end
end
