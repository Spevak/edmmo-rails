class MapController < ApplicationController
  def editor
    unless Rails.env.development? then
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
