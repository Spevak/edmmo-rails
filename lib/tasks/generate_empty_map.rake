task :generate_jank_map => :environment do
  Tile.destroy_all
  (0..Tile.MAP_SIDE_LENGTH).each do |i|
    (0..Tile.MAP_SIDE_LENGTH).each do |j|
      if (i == 0 or j == 0 or (i == 2 and j < 4)) then
        Tile.create(x: i, y: j, tile_type: 4)
      else
        Tile.create(x: i, y: j, tile_type: rand(3).to_i)
      end
    end
  end
end
