class CreateUsersBgPacks < ActiveRecord::Migration
  def change
    create_join_table :users, :bg_packs do |t|
      t.index :user_id
      t.index :bg_pack_id
    end
  end
end
