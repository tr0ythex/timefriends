class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors }, status: :unprocessable_entity
    end
  end
  
end