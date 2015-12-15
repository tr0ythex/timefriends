class Api::V1::UsersController < ApplicationController
  
  # def index
  #   @users = User.all
  #   respond_with @users
  #   render json: @users
  # end
    
  def show
  end
    
  def create
    @user = User.create(user_params)
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
    # respond_with :api, :v1, @user
    # render json: [:api, :v1, @user]
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password)
    end
end