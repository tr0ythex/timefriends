class Post < ActiveRecord::Base
  # has_many :users
  # has_many :accessions
  has_many :invited_friends, through: :accessions, source: :users
  # has_many :users, through: :invited_friends
  
  belongs_to :user
  has_many :comments
  
  validates :body, :datetime, :place, presence: true
  validates :auto, inclusion: [true, false]
end