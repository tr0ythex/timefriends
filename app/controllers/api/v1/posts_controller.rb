class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :index, :update, :destroy, :join, :leave, :feed, :post_days]
  
  def index
    user = User.find_by(id: params[:user_id])
    if user
      if params[:date]
        render json: user.posts
          .where(created_at_date, params[:date]).includes(comments: :user)
          .to_json(
            :except => :user_id, 
            :include => [
               {:user => { only: [:id, :login, :photo_url] }}, 
               {:joined_users => { only: :id }},
               {:comments => {
                  only: [:id, :body],
                  :include => [
                    {:user => { only: :login }}
                  ]
               }}
            ]
          )
      else
        render json: user.posts.includes(comments: :user).group_by{|p| p.created_at.to_date}.to_json(
          :except => :user_id, 
          :include => [
             {:user => { only: [:id, :login, :photo_url] }}, 
             {:joined_users => { only: :id }},
             {:comments => {
                only: [:id, :body],
                :include => [
                  {:user => { only: :login }}
                ]
             }}
          ])
      end
    else
      render json: { errors: "No such user" }, status: :unprocessable_entity
    end
  end
  
  def feed
    posts = []
    wrong_arg = false
    
    case params[:feed]
    when "my"
      posts = my_posts(params[:date])
    when "friends"
      posts = friends_posts(params[:date])
    when "all"
      posts = my_posts(params[:date]) + friends_posts(params[:date])
    else
      wrong_arg = true
    end
    
    if !wrong_arg
      if !params[:date]
        posts = posts.group_by{|p| p.created_at.to_date}
      end
      render json: posts.to_json(
        :except => :user_id, 
        :include => [
          {:user => { only: [:id, :login, :photo_url] }}, 
          {:joined_users => { only: :id }},
          {:comments => {
            only: [:id, :body],
            :include => [
              {:user => { only: :login }}
            ]
          }}
        ]
      )
    else
      render json: { errors: "Wrong argument after posts" }, status: :unprocessable_entity
    end
    

  end
  
  def my_posts(date)
    my_posts = []
    if !date
      my_posts = current_user.posts.includes(comments: :user)
    else
      my_posts = current_user.posts.where(created_at_date, date).includes(comments: :user)
    end
    my_posts
  end
  
  def friends_posts(date)
    friends_posts = []
    if !date
      current_user.friends.to_a.each do |friend|
        friends_posts += friend.posts.includes(comments: :user)
      end
    else
      current_user.friends.to_a.each do |friend|
        friends_posts += friend.posts.where(created_at_date, date).includes(comments: :user)
      end
    end
    friends_posts
  end
  
  def post_days
    post_days = []
    
    post_proc = Proc.new do |post|
      if post.created_at.year == params[:year].to_i && 
         post.created_at.month == params[:month].to_i
        if !post_days.include?(post.created_at.day)
          post_days << post.created_at.day
        end
      end
    end
    
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      user.posts.each(&post_proc)
    else
      current_user.posts.each(&post_proc)
    end
    
    render json: post_days
  end
  
  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    post = current_user.posts.find(params[:id])
    if post.update(post_params)
      head :ok
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    current_user.posts.find(params[:id]).destroy
    head :ok
  end
  
  def join
    post = Post.find(params[:id])
    # if it's not your post
    if !current_user.posts.include?(post)
      # if you have not already joined this post
      if !post.joined_users.include?(current_user)
        post.joined_users << current_user
        render json: { success: "You successfully joined to this post" }, status: :ok
        
        # Prepare pushes
        p_user = post.user
        p_user_pushes = []
        p_user.devices.each do |device| # collect pushes for all user devices
          p_user_pushes << APNS::Notification.new(device.token, 
              :alert => "#{I18n.t :post_joining_push, user: current_user.login, post: post.body}",
              :badge => 1, :sound => 'default', :other => {:sent => {:photo_url => current_user.photo_url, :type => 2}})
        end
        # Send pushes to all user devices
        APNS.send_notifications(p_user_pushes) unless p_user_pushes.empty?
      else
        render json: { errors: "You have already joined to this post" }, status: :unprocessable_entity
      end
    else
      render json: { errors: "You can't join to your post" }
    end
  end
  
  def leave
    post = Post.find(params[:id])
    if post.joined_users.include?(current_user)
      post.joined_users.destroy(current_user)
      render json: { success: "You successfully leaved this post" }, status: :ok
    else
      render json: { errors: "You are not joined to this post" }, status: :unprocessable_entity
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:body, :start_time, :end_time, :place, :latitude, :longitude, 
      :auto, :joined_user_ids => [] )
  end
end