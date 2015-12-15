class AddDefaultValueToHideAcc < ActiveRecord::Migration
  def change
    change_column :users, :hide_acc, :boolean, :default => false
  end
end
