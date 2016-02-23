class Device < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true, uniqueness: { scope: :user_id }
end