class AddVkidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vkid, :string
  end
end
