class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :password_digest
      t.boolean :hide_acc
      t.binary :photo
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
