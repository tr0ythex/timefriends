class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :index, :update, :delete]
  
  def index
    @user = User.find(params)
    if params[:date]
      render json: current_user.posts.includes(:comments).where("strftime('%Y-%m-%d', created_at) = ?", params[:date])
    else
      render json: current_user.posts.includes(:comments)
    end
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
    
  end
  
  private
  
  def post_params
    params.require(:post).permit(:body, :datetime, :place, :latitude, :longitude, :auto)
  end
end