class RenameDatetimeAndAddEndTimeToPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :datetime, :start_time
    add_column :posts, :end_time, :datetime
  end
end