class Api::V1::BaseController < ApplicationController

  before_action :validate

  def request_valid?(request, session)
    #requested_user = request[:user_id]
    #session_user   = current_user
    #if session_user == nil or requested_user == nil then
    #  return false
    #end
    #return requested_user == session_user.id
    true
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
