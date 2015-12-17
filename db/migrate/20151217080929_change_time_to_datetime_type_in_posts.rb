class ChangeTimeToDatetimeTypeInPosts < ActiveRecord::Migration
  def change
    change_column :posts, :time,  :datetime
  end
end
