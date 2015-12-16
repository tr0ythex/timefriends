class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  # before_action :ensure_json_request  

  # def ensure_json_request  
  #   return if request.format == :json
  #   render :nothing => true, :status => 406  
  # end 
  
  private
  
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
  
  def authenticate_with_token!
    head :unauthorized unless current_user.present?
  end
  
  # helper_method :current_user
end
