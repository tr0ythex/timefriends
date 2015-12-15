class Post < ActiveRecord::Base
  has_many :invited_friends, dependent: :destroy
  has_many :users, through: :invited_friends
end