class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    post = Post.find_by(id: params[:post_id])
    if post
      comment = post.comments.build(comment_params)
      comment.user = current_user
      if comment.save
        render json: comment, status: :created
      else
        render json: { errors: comment.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: "Post with id '#{params[:post_id]}' doesn't exist" }
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end