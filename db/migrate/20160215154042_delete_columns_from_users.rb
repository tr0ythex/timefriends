class DeleteColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :photo_file_name
    remove_column :users, :photo_content_type
    remove_column :users, :photo_file_size
    remove_column :users, :photo_updated_at
  end
end
