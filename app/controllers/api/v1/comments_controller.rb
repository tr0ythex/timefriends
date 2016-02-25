class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    post = Post.find_by(id: params[:post_id])
    if post
      comment = post.comments.build(comment_params)
      comment.user = current_user
      if comment.save
        render json: comment, status: :created
        p_user = post.user
        p_user_pushes = []
        p_user.devices.each do |device|
          p_user_pushes << APNS::Notification.new(device.token, 
              :alert => "Новый комментарий")
        end
        # Send pushes to all user devices
        APNS.send_notifications(p_user_pushes) unless p_user_pushes.empty?
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