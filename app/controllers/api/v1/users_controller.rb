class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  
  def show
  end
    
  def create
    @user = User.create(user_params)
    if @user.save
      # render json: @user, status: :created
      head :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    current_user.destroy
    head :no_content
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password, :hide_acc, :photo, :first_name, :last_name)
    end
end