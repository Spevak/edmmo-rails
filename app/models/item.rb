class Item < ActiveRecord::Base
    has_many :characters
    has_one :tile

    def use(character_id, x, y)
    end
end
