class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(login: session_params[:login])
    if user && user.authenticate(session_params[:password])
      user.generate_auth_token!
      user.save
      render json: user.auth_token, status: :ok
    else
      render json: { errors: "Invalid login or password" }, status: :unprocessable_entity
    end
  end
  
  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_auth_token!
    user.save
    head 204
  end

  private
  def session_params
    params.require(:user).permit(:login, :password)
  end
end