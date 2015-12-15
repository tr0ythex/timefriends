class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(login: session_params[:login])
    if user && user.authenticate(session_params[:password])
      render json: user.auth_token, status: :ok
    else
      render json: { errors: "Invalid login or password" }, status: :unprocessable_entity
    end
  end

  private
  def session_params
    params.require(:user).permit(:login, :password)
  end
end