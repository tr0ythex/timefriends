class Post < ActiveRecord::Base
  belongs_to :user
  has_many :joined_users, through: :accessions, class_name: 'User'
  has_many :accessions
  
  has_many :comments
  
  validates :body, :start_time, :end_time, :place, presence: true
  validates :auto, inclusion: [true, false]
end