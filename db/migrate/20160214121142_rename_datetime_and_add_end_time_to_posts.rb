class RenameDatetimeAndAddEndTimeToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :datetime
    # change_column :posts, :start_time, 'datetime USING CAST(start_time AS datetime)'
    add_column :posts, :start_time, :datetime
    add_column :posts, :end_time, :datetime
  end
end