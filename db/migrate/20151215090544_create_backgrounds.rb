class CreateBackgrounds < ActiveRecord::Migration
  def change
    create_table :backgrounds do |t|
      t.binary :bg

      t.timestamps null: false
    end
  end
end
