class MapController < ApplicationController
  def editor
    unless Rails.env.development? then
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  def load
    x = request[:x]
    y = request[:y]
    filename = "config/map/" + x.to_s + "-" + y.to_s + ".json"
    file = open(filename)
    render :json => file.read
  end
end
