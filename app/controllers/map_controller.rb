class MapController < ApplicationController

  def editor
    unless Rails.env.development? then
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def load
    x = request[:x]
    y = request[:y]
    filename = "config/map/init/" + x.to_s + "-" + y.to_s + ".json"
    puts "loading " + filename
    if Dir["config/map/init/*"].include? filename then
      file = open(filename)
      render :json => file.read
    else
      render :json => {:tiles => []}
    end
  end

  def save
    x = request[:x]
    y = request[:y]
    tiles = request[:tiles]
    filename = "config/map/init/" + x.to_s + "-" + y.to_s + ".json"
    if tiles != nil then
      if Dir["config/map/init/*"].include? filename then
        File.delete(filename)
      end
      file = open(filename, "w")
      file.write("{ \n  \"tiles\":[\n")
      (0..tiles.size-1).each do |index|
        tile = tiles[index]
        file.write("    {\"x\": " + tile["x"].to_s + ", \"y\": " + tile["y"].to_s +
                   ", \"id\": " + tile["id"].to_s + "}")
        if index != tiles.size-1 then file.write(",") end
        file.write("\n");
      end
      file.write("  ]\n}\n")
      file.close
    end
    render nothing: true
  end
end

