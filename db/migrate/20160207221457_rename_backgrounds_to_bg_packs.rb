class RenameBackgroundsToBgPacks < ActiveRecord::Migration
  def change
    rename_table :backgrounds, :bg_packs
  end
end
