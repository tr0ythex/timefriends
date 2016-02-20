class ChangeStarttimeColumnTypeInPosts < ActiveRecord::Migration
  def change
    change_column :posts, :start_time, 'timestamp USING CAST(start_time AS timestamp)'
  end
end