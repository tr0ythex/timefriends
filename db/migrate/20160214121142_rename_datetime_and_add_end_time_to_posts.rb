class RenameDatetimeAndAddEndTimeToPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :datetime, :start_time
    change_column :posts, :start_time, 'USING start_time::timestamp without time zone'
    add_column :posts, :end_time, :datetime
  end
end