class User < ActiveRecord::Base
  before_validation :generate_authentication_token
  
  has_secure_password
    
  private
  
  def generate_auth_token
    return if auth_token.present?
    
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end
end