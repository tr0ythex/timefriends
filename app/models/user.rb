class User < ActiveRecord::Base
  before_create :generate_auth_token!
  
  has_secure_password # presence of password
  has_friendship # has_friendship gem
  
  has_many :posts
  
  has_and_belongs_to_many :backgrounds
  
  has_many :invites_by_posts, class_name: 'InvitedFriend', dependent: :destroy
  has_many :posts, through: :invites_by_posts
  
  validates :auth_token, uniqueness: true
  validates :login, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :hide_acc, inclusion: [true, false]
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  
  def generate_auth_token!
    # return if auth_token.present?
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end
end