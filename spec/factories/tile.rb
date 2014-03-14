FactoryGirl.define do  
  
  side_length = Tile.MAP_SIDE_LENGTH

  # These are kept separate so that they increment separately
  sequence :x do |n|
    n % side_length
  end

  sequence :y do |n|
    # e.g. 1, 1, 1, 1...(side_length 1's), 2, 2, 2, 2... (side_length 2's...)
    ((n/side_length).ceil) % side_length
  end

  factory :tile do
    x { generate(:x) }
    y { generate(:y) }
    tile_type 0
    item
    character
    after(:build) { |t| t.xn_plus_y = (t.x * side_length) + t.y }
  end

  factory :tile_empty, class: Tile do
    x { generate(:x) }
    y { generate(:y) }
    tile_type 0
    item_id nil
    character_id nil
    after(:build) { |t| t.xn_plus_y = (t.x * side_length) + t.y }
  end

end
