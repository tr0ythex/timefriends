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
      # only: user_json_params.tap(&:pop)
    else
      render json: { errors: "No such user" }, status: :unprocessable_entity
    end
  end
    
  def create
    # image = Paperclip.io_adapters.for(params[:user][:photo_data]) 
    # image.original_filename = "something.png"
    image = parse_image_data(params[:user][:photo_data])
    
    user = User.create(login: params[:user][:login], password: params[:user][:password], email: params[:user][:email], photo: image)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end

    # StringIO.open(params[:user][:photo_data]) do |s|
    #   user.photo = s
    #   user.photo_file_name = "something.png"
    #   user.photo_content_type = 'image/png'
    # end
    
    # , photo: image)
    # tempfile = params[:file].tempfile.path
    
    # tempfile = image.tempfile.path
    # if File::exists?(tempfile)
    #   File::delete(tempfile)
    # end
    # render json: tempfile
    
    # user = User.create(convert_data_uri_to_upload(user_params))
    # if user.save
    #   render json: user.as_json(only: user_json_params)
    #     .merge(friends_count: user.friends.count), status: :created
    # else
    #   render json: { errors: user.errors }, status: :unprocessable_entity
    # end
  ensure
    clean_tempfile
  end
  
  def parse_image_data(image_data)
    # @tempfile = Tempfile.new('item_image')
    # @tempfile.binmode
    # @tempfile.write Base64.decode64(image_data)
    # @tempfile.rewind

    # uploaded_file = ActionDispatch::Http::UploadedFile.new(
    #   tempfile: @tempfile,
    #   filename: 'sdfs'
    # )
    # @tempfile.unlink
    # uploaded_file.content_type = image_data[:content_type]
    # uploaded_file
    
    image_data = split_base64(image_data)
	  image_data_string = image_data[:data]
	  image_data_binary = Base64.decode64(image_data_string)

	    temp_img_file = Tempfile.new("")
	    temp_img_file.binmode
	    temp_img_file << image_data_binary
	    temp_img_file.rewind

	    img_params = {:filename => "image.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
	    uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

	    temp_img_file.unlink
      uploaded_file
  end

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end
  
  def split_base64(uri_str)
	  if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
	    uri = Hash.new
	    uri[:type] = $1 # "image/gif"
	    uri[:encoder] = $2 # "base64"
	    uri[:data] = $3 # data string
	    uri[:extension] = $1.split('/')[1] # "gif"
	    return uri
	  else
	    return nil
	  end
  end
  
  # def convert_data_uri_to_upload(obj_hash)
	 # if obj_hash[:photo_url].try(:match, %r{^data:(.*?);(.*?),(.*)$})
	 #   image_data = split_base64(obj_hash[:photo_url])
	 #   image_data_string = image_data[:data]
	 #   image_data_binary = Base64.decode64(image_data_string)

	 #   temp_img_file = Tempfile.new("")
	 #   temp_img_file.binmode
	 #   temp_img_file << image_data_binary
	 #   temp_img_file.rewind

	 #   img_params = {:filename => "image.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
	 #   uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

	 #   obj_hash[:photo] = uploaded_file
	 #   obj_hash.delete(:photo_url)
	 #   temp_img_file.unlink
	 # end
  # 	return obj_hash    
  # end
  
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