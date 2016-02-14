class User < ActiveRecord::Base
  before_create :generate_auth_token!
  
  has_secure_password # presence of password
  has_friendship # has_friendship gem
  has_attached_file :photo, styles: { small: "64x64", med: "100x100", large: "200x200" }
  
  has_many :posts
  has_many :joining_posts, through: :accessions, class_name: 'Post'
  has_many :accessions
  
  has_and_belongs_to_many :bg_packs
  
  validates :auth_token, uniqueness: true
  validates :login, :email, presence: true, uniqueness: true
  validates :hide_acc, inclusion: [true, false]

  def generate_auth_token!
    # return if auth_token.present?
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end
end