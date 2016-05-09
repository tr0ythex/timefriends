class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, 
      only: [:update, :destroy, :send_friendship_offer, 
             :accept_friendship_offer, 
             :decline_friendship_offer, 
             :requested_friends, :pending_friends, 
             :friends, :friends_with, :remove_friend, :update_locale]
  
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
    user = User.new(user_params)
    # user.login = params[:user][:login]
    # user.email = params[:user][:email]
    # user.password = params[:user][:password]
    
    if user.save
      # I18n.locale = user_params[:locale] || I18n.default_locale
      render json: user.as_json(only: user_json_params)
        .merge(friends_count: user.friends.count), status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end
  
  def decode_picture_data picture_data
    data = Paperclip.io_adapters.for(picture_data)
    data.original_filename = "upload.png"
    data.content_type = "image/png"
    data
  end
  
  def update
    user = current_user
    
    # update photo
    if params[:user][:photo_data]
      photo = decode_picture_data(params[:user][:photo_data])
      if user.update(photo: photo)
        user.update(photo_url: user.photo.url)
        render json: user.as_json(only: user_json_params)
          .merge(friends_count: user.friends.count), status: :ok
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
    
    # update custom background
    if params[:user][:custom_bg_data]
      custom_bg = decode_picture_data(params[:user][:custom_bg_data])
      if user.update(custom_bg: custom_bg)
        user.update(custom_bg_url: user.custom_bg.url)
        render json: user.as_json(only: user_json_params)
          .merge(friends_count: user.friends.count), status: :ok
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
    
    unless params[:user][:photo_data] || params[:user][:custom_bg_data]
      # update other user params
      if user.update(user_params)
        render json: user.as_json(only: user_json_params)
          .merge(friends_count: user.friends.count), status: :ok
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  end
  
  def destroy
    current_user.destroy
    head :no_content
  end
  
  def update_locale
    if user.update(params[:user][:locale])
      render json: user.as_json(only: user_json_params)
        .merge(friends_count: user.friends.count), status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
  
  def send_friendship_offer
    f_user = User.find_by(login: params[:login])
    if current_user.friend_request(f_user)
      # Collect device tokens in array of pushes
      I18n.locale = f_user.locale || I18n.default_locale
      f_user_pushes = []
      f_user.devices.each do |device|
        f_user_pushes << APNS::Notification.new(device.token, 
            :alert => "#{I18n.t :friend_request_push, user: current_user.login}",
            :badge => 1, :sound => 'default', :other => {:sent => {:photo_url => current_user.photo_url, :type => 0}})
      end
      # Send pushes to all user devices
      APNS.send_notifications(f_user_pushes) unless f_user_pushes.empty?
      
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
  
  def remove_friend
    r_friend = User.find_by(login: params[:login])
    if r_friend
      if r_friend == current_user
        render json: { errors: "You can't be your friend" }, status: :unprocessable_entity
      else
        if current_user.friends_with?(r_friend)
          current_user.remove_friend(r_friend)
          render json: { success: "You successfully removed #{r_friend.login} from your friends" }
        else
          render json: { errors: "#{r_friend.login} is not your friend" },
              status: :unprocessable_entity
        end
      end
    else
      render json: { errors: "There's no such user" }, status: :unprocessable_entity
    end
  end
  
  def requested_friends
    render json: current_user.requested_friends.to_a, only: user_json_params.tap(&:pop)
  end
  
  def pending_friends
    render json: current_user.pending_friends.to_a, only: user_json_params.tap(&:pop)
  end
  
  def friends
    users_output = []
    if params[:user_id]
      f_user = User.find(params[:user_id])
      f_user.friends.to_a.each do |user|
        users_output << user.as_json(only: user_json_params.tap(&:pop))
          .merge(friends_count: user.friends.count)
      end
    else
      current_user.friends.to_a.each do |user|
        users_output << user.as_json(only: user_json_params.tap(&:pop))
          .merge(friends_count: user.friends.count)
      end
    end
    
    render json: users_output
  end
  
  def friends_with
    user = User.find_by(login: params[:login])
    if user
      if current_user == user
        render json: { errors: "You can't be your friend" }, status: :unprocessable_entity
      else
        if current_user.friends.where(login: user.login).present?
          render json: { success: "#{user.login} is your friend" }
        else
          render json: { success: "#{user.login} isn't your friend" }
        end
      end
    else
      render json: { errors: "User '#{params[:login]}' doesn't exist" }, status: :unprocessable_entity
    end
  end
    
  private
    def user_params
      params.require(:user).permit(:login, :email, :password, :hide_acc, 
          :photo_url, :custom_bg_url, :first_name, :last_name, :vkid, :background_url, :locale,
          :devices_attributes => [:token])
    end
end