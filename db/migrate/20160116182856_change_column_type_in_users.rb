class ChangeColumnTypeInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :photo, :photo_url
    change_column :users, :photo_url, :string
  end
end
