class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.time :time
      t.string :place
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :auto

      t.timestamps null: false
    end
  end
end
