class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :index]
  
  def index
    render json: current_user.posts
  end
  
  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors }, status: :unprocessable_entity
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:body, :time, :place, :latitude, :longitude, :auto)
  end
end