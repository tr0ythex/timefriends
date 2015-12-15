class Post < ActiveRecord::Base
  has_many :invited_friends, dependent: :destroy
  has_many :users, through: :invited_friends
  
  belongs_to :user
  has_many :comments
end