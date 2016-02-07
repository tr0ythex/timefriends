class AddBgPackReferenceToBackgrounds < ActiveRecord::Migration
  def change
    add_reference :backgrounds, :bg_pack, index: true, foreign_key: true
  end
end
