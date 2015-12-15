class Api::V1::UsersController < ApplicationController
  def show
  end
    
  def create
    @user = User.create(user_params)
    if @user.save
      # render json: @user, status: :created
      render :nothing => true, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password)
    end
end