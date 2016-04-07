class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    post = Post.find_by(id: params[:post_id])
    if post
      comment = post.comments.build(comment_params)
      comment.user = current_user
      if comment.save
        render json: comment, status: :created
        
        # Prepare pushes
        p_user = post.user
        I18n.locale = p_user.locale || I18n.default_locale
        p_user_pushes = []
        p_user.devices.each do |device|
          p_user_pushes << APNS::Notification.new(device.token, 
              :alert => "#{I18n.t :new_comment_push, user: comment.user.login, post: comment.post.body}",
              :badge => 1, :sound => 'default', :other => {:sent => {:photo_url => comment.user.photo_url, :type => 1}})
        end
        # Send pushes to all user devices
        APNS.send_notifications(p_user_pushes) unless p_user_pushes.empty?
      else
        render json: { errors: comment.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: "Post with id '#{params[:post_id]}' doesn't exist" },
        status: :unprocessable_entity
    end
  end
  
  def destroy
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    if current_user.posts.where(id: post.id).present? || 
       current_user.comments.where(id: comment.id).present?
      comment.destroy
      head :ok
    else
      head :unprocessable_entity
    end
    
  end
  
  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end