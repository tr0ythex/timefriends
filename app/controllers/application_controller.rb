class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  private
  
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
  
  def authenticate_with_token!
    head :unauthorized unless current_user.present?
  end
  
  def user_json_params
    [:id, :username, :login, :email, :hide_acc, :photo_url, 
     :first_name, :last_name, :vkid, :background_url, :auth_token]
  end
  
  def created_at_date
    if Rails.env.production? # for postgres
      "to_char(created_at, 'YYYY-MM-DD') = ?"
    else # for sqlite
      "strftime('%Y-%m-%d', created_at) = ?"
    end
  end
end
