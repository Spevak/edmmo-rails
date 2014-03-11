class Api::V1::PlayersController < Api::V1::BaseController

  before_filter :validate

  def move_to(direction)
    direction = request[:direction]
    user_location = User.
  end

  def pick_up(x, y, item_id)
  end

  def use_item(x, y)
  end
end
