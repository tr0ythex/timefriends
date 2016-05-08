class AddCustomBgUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_bg_url, :string
  end
end
