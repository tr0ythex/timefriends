class RemoveDatetimeAndAddStarttimeToPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :datetime, :start_time
    change_column :posts, :start_time, 'datetime USING CAST(start_time AS datetime)'
    add_column :posts, :end_time, :datetime
  end
end