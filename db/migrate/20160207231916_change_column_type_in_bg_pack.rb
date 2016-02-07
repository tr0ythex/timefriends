class ChangeColumnTypeInBgPack < ActiveRecord::Migration
  def change
    change_column :bg_packs, :name, :string
  end
end
