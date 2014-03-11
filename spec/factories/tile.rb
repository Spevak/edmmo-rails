FactoryGirl.define do  

  # These are kept separate so that they increment separately
  sequence :x do |n|
    n
  end

  sequence :y do |n|
    n
  end

  factory :tile do
    x { generate(:x) }
    y { generate(:y) }
    type 0
    item_id nil
    character_id nil
    after(:build) { |t| t.xn_plus_y = (t.x * Tile.MAP_SIDE_LENGTH) + t.y }
  end

end
