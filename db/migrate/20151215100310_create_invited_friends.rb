class CreateInvitedFriends < ActiveRecord::Migration
  def change
    create_table :invited_friends do |t|
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
