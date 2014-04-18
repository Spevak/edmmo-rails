FactoryGirl.define do

  factory :item do
    pickupable true
    walkoverable true
    consumable true
    battery_effect 0
    health_effect 0
    default_message ""
    affects ""
    item_type ""
  end

  ITEM_PROPERTIES.keys.each do |key|
    item = ITEM_PROPERTIES[key]
    factory item["type"].to_sym, class: Item do
     pickupable item["pickupable"]
      walkoverable item["walkoverable"]
      consumable item["consumable"]
      battery_effect item["batteryEffect"]
      health_effect item["healthEffect"]
      default_message item["defaultMessage"]
      affects item["affects"]
      item_type item["type"]
      moves_player_x item["coordsEffects"]["x"]
      moves_player_y item["coordsEffects"]["y"]
    end
  end
end
