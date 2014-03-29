FactoryGirl.define do  
  
  side_length = Tile.MAP_SIDE_LENGTH

  # These are kept separate so that they increment separately
  sequence :x, 0 do |n|
    n % side_length
  end

  sequence :y, 0 do |n|
    # e.g. 0, 0, 0, 0...(side_length 0's), 1, 1, 1, 1... (side_length 1's...)
    ((n/side_length).ceil) % side_length
  end

  factory :tile do
    x { generate(:x) }
    y { generate(:y) }
    item
    character
    tile_type 0
    after(:build) { |t| t.xn_plus_y = (t.x * side_length) + t.y }
  end

  factory :tile_empty, class: Tile do
    x { generate(:x) }
    y { generate(:y) }
    item nil
    character nil
    tile_type 0
    after(:build) { |t| t.xn_plus_y = (t.x * side_length) + t.y }
  end

end
