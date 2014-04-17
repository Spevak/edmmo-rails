# An item in BotQuest.
class Item < ActiveRecord::Base
  has_one :inventory
  has_one :character
  has_many :tiles

  # Modify my singleton class.
  # http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby
  class << self

    # Build an item from the item_data.
    # item_data should be a hash.
    def build(item_data) 
      item = Item.new
    end

    # Make my constructor private.
    #private :new
  end

end
