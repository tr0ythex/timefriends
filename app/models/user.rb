class User < ActiveRecord::Base
  before_create :generate_auth_token!
  
  has_secure_password # presence of password
  has_friendship # has_friendship gem
  
  has_attached_file :photo, 
    :url => "/users/:id/:basename.:extension",
    :path => ":rails_root/public/users/:id/:basename.:extension",
    :default_url => "/users/nothing.png"
  # styles: { small: "64x64", med: "100x100", large: "200x200" }
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_file_name :photo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  
  has_attached_file :custom_bg, 
    :url => "/users/:id/bg/:basename.:extension",
    :path => ":rails_root/public/users/:id/bg/:basename.:extension",
    :default_url => "/users/:id/bg/nothing.png"
  validates_attachment :custom_bg, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_file_name :custom_bg, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  has_many :posts, dependent: :destroy
  has_many :joining_posts, through: :accessions, class_name: 'Post'
  has_many :accessions
  
  has_many :comments, dependent: :destroy # !!! !!!
  
  has_and_belongs_to_many :bg_packs
  
  has_many :devices, dependent: :destroy
  # validates :devices, presence: true
  accepts_nested_attributes_for :devices
  
  validates :auth_token, uniqueness: true
  validates :login, :email, presence: true, uniqueness: true
  validates :hide_acc, inclusion: [true, false]
  validates :locale, presence: true

  def generate_auth_token!
    # return if auth_token.present?
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end
end