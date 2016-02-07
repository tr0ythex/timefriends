class CreateBgPacks < ActiveRecord::Migration
  def change
    create_table :bg_packs do |t|
      t.string :device_type
      t.time :name

      t.timestamps null: false
    end
  end
end
