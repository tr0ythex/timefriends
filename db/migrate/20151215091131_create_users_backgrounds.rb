class CreateUsersBackgrounds < ActiveRecord::Migration
  def change
    create_join_table :users, :backgrounds do |t|
      t.index :user_id
      t.index :background_id
    end
  end
end
