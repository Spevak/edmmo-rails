class Item < ActiveRecord::Base
    has_many :characters
    has_many :tiles

    def use(character_id, x, y)
    end
end
