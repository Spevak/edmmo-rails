class Api::V1::BaseController < ApplicationController

  before_action :validate
  skip_before_action :verify_authenticity_token #if Rails.env.development?

  def request_valid?(request, session)
    puts "request: #{request}"
    puts "session: #{session}"
    requested_user = request[:player_id]
    session_user   = current_user
    puts "requested user: #{requested_user}"
    puts "session user: #{session_user}"
  end
  
  def test_session
    authed = request_valid?(request, session)
    render json: { "authed" => authed.to_s }
  end

  # All methods underneath are private
  private
  def validate
    unless request_valid?(request, session)
      render json: {}, status: :forbidden
    end
  end

end
