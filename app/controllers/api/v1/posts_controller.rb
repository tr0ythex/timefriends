class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: :create
  
  def create
    post1 = current_user.posts.build(post_params)
    if post1.save
      render json: post1, status: :created
    else
      render json: { errors: post1.errors }, status: :unprocessable_entity
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:body, :time, :place, :latitude, :longitude, :auto)
  end
end