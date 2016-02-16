class User < ActiveRecord::Base
  before_create :generate_auth_token!
  
  has_secure_password # presence of password
  has_friendship # has_friendship gem
  has_attached_file :photo, styles: { small: "64x64", med: "100x100", large: "200x200" }
  
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment_file_name :photo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  
  # attr_accessor :photo_data
  # before_save :decode_photo_data
  
  has_many :posts
  has_many :joining_posts, through: :accessions, class_name: 'Post'
  has_many :accessions
  
  has_and_belongs_to_many :bg_packs
  
  validates :auth_token, uniqueness: true
  validates :login, :email, presence: true, uniqueness: true
  validates :hide_acc, inclusion: [true, false]
  # attr_accessor :photo
  # mount_uploader :photo_url, AttachmentUploader

  def generate_auth_token!
    # return if auth_token.present?
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end
  
  # def decode_photo_data
  #   if self.photo_data.present?
  #     # If image_data is present, it means that we were sent an image over
  #     # JSON and it needs to be decoded.  After decoding, the image is processed
  #     # normally via Paperclip.
  #     data = StringIO.new(Base64.decode64(self.photo_data))
  #     data.class.class_eval {attr_accessor :original_filename, :content_type}
  #     data.original_filename = self.id.to_s + ".png"
  #     data.content_type = "image/png"

  #     self.photo = data
  #   end
  # end
end