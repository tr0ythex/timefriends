class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, 
      only: [:update, :destroy, :send_friendship_offer, 
             :accept_friendship_offer, :friendship_offers, :friends]
  
  def index
    @users = User.all
    @users = @users.limit(params[:limit]) if params[:limit]
    @users = @users.offset(params[:offset]) if params[:offset]
    
    render json: @users, only: [:id, :login, :email, :hide_acc, :photo_url,
      :first_name, :last_name, :auth_token]
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user
      render json: @user, only: [:id, :login, :email, :hide_acc, :photo_url,
          :first_name, :last_name, :auth_token]
    else
      render json: { errors: "No such user" }, status: :unprocessable_entity
    end
  end
    
  def create
    @user = User.create(user_params)
    if @user.save
      render json: { auth_token: @user.auth_token }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    user = current_user

    if user.update(user_params)
      head :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    current_user.destroy
    head :no_content
  end
  
  def send_friendship_offer
    if current_user.friend_request(User.find_by(login: params[:login]))
      render json: { info: "Invitation sent" }, status: :ok
    else
      render json: { errors: "Invitation has already been sent" }, status: :bad_request
    end
  end
  
  def accept_friendship_offer
    if current_user.accept_request(User.find_by(login: params[:login]))
      render json: { info: "Invitation accepted" }
    else
      render json: { errors: "Invitation has already been accepted" }, status: :bad_request
    end
  end
  
  def friendship_offers
    render json: current_user.requested_friends.to_a
  end
  
  def friends
    render json: current_user.friends.to_a
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password, :hide_acc, :photo, :first_name, :last_name)
    end
end