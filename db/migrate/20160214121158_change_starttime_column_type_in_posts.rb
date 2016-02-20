class ChangeStarttimeColumnTypeInPosts < ActiveRecord::Migration
  def change
    change_column :posts, :start_time, :datetime
  end
end