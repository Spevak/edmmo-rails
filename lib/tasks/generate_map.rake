" Generates a large empty set of map tiles. "
task :generate_map => :environment do
  (0..Tile.MAP_SIDE_LENGTH).each do |i|
    (0..Tile.MAP_SIDE_LENGTH).each do |j|
      Tile.create(x: i, y: j, tile_type: 0)
    end
  end
end
