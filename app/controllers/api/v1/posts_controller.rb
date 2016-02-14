class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :index, :update, :destroy, :join, :leave, :feed, :post_days]
  
  def index
    user = User.find_by(id: params[:user_id])
    if user
      if params[:date]
        render json: user.posts.includes(:comments).where("strftime('%Y-%m-%d', created_at) = ?", params[:date])
      else
        render json: user.posts.to_json(:except => :user_id, 
            :include => {:user => {only: [:id, :login, :photo_url]}})
      end
    else
      render json: { errors: "No such user" }, status: :unprocessable_entity
    end
  end
  
  def feed
    posts = []
    posts += current_user.posts
    
    if params[:feed] == "all"
      current_user.friends.to_a.each do |friend|
        posts += friend.posts
      end
    end
    
    render json: posts.to_json(:except => :user_id, 
        :include => {:user => {only: [:id, :login, :photo_url]}})
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
    if !current_user.posts.include?(post)
      if !post.joined_users.include?(current_user)
        post.joined_users << current_user
        render json: { success: "You successfully joined to this post" }, status: :ok
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