class Accession < ActiveRecord::Base
  belongs_to :joined_user, foreign_key: :user_id, class_name: 'User'
  belongs_to :joining_post, foreign_key: :post_id, class_name: 'Post'
end