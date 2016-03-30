class RenameDatetimeAndAddEndTimeToPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :datetime, :start_time
    change_column :posts, :start_time, :timestamp
    add_column :posts, :end_time, :datetime
  end
end