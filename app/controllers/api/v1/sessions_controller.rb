class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!, only: :destroy
  
  def create
    user = User.find_by(login: session_params[:login])
    if user && user.authenticate(session_params[:password])
      if session_params[:device_token]
        device_token = session_params[:device_token]
        # if device_token not presented add user new device
        if !user.devices.where(token: device_token).present?
          user.devices.create(token: device_token)
        end
      end
      render json: user.as_json(only: user_json_params)
          .merge(friends_count: user.friends.count), status: :ok
    else
      render json: { errors: "Invalid login or password" }, status: :unprocessable_entity
    end
  end
  
  def destroy
    user = current_user
    user.devices.where(token: params[:device_token]).destroy_all
    
    user.generate_auth_token!
    user.save
    head :ok
  end

  private
  
  def session_params
    params.require(:user).permit(:login, :password, :device_token)
  end
end