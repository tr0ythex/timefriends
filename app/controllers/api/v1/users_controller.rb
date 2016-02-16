class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, 
      only: [:update, :destroy, :send_friendship_offer, 
             :accept_friendship_offer, 
             :decline_friendship_offer, 
             :friendship_offers, :friends]
  
  def index
    users = User.all
    users = users.limit(params[:limit]) if params[:limit]
    users = users.offset(params[:offset]) if params[:offset]

    users_output = []
    users.each do |user|
      users_output << user.as_json(only: user_json_params.tap(&:pop))
        .merge(friends_count: user.friends.count)
    end
    render json: users_output
  end
  
  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user.as_json(only: user_json_params.tap(&:pop))
        .merge(friends_count: user.friends.count)
    else
      render json: { errors: "No such user" }, status: :unprocessable_entity
    end
  end
    
  def create
    user = User.create(user_params)
    if user.save
      render json: user.as_json(only: user_json_params)
        .merge(friends_count: user.friends.count), status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
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
      render json: { success: "Invitation sent" }, status: :ok
    else
      render json: { errors: "Invitation has already been sent" }, status: :unprocessable_entity
    end
  end
  
  def accept_friendship_offer
    a_user = User.find_by(login: params[:login])
    if current_user.requested_friends.where(login: a_user.login).present?
      if current_user.accept_request(a_user)
        render json: { success: "Invitation accepted" }
      else # should never come into this block
        render json: { errors: "Invitation has already been accepted" }, status: :unprocessable_entity
      end
    else
      render json: { errors: "There's no incoming request from #{a_user.login}" }, status: :unprocessable_entity
    end
  end
  
  # двустороннее отклонение запроса в друзья
  def decline_friendship_offer
    d_user = User.find_by(login: params[:login])
    if current_user.pending_friends.where(login: d_user.login).present? ||
          current_user.requested_friends.where(login: d_user.login).present?
      current_user.decline_request(d_user)
      render json: { success: "Friendship request for user #{d_user.login} has been declined" }
    else
      render json: { errors: "There are no incoming or outcoming requests for #{d_user.login}" },
          status: :unprocessable_entity
    end
  end
  
  def friendship_offers
    render json: current_user.requested_friends.to_a, only: user_json_params.tap(&:pop)
  end
  
  def friends
    render json: current_user.friends.to_a, only: user_json_params.tap(&:pop)
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password, :hide_acc, :photo_url, :first_name, :last_name, :vkid)
    end
end