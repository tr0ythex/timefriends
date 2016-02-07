class AddBgUrlToBackgrounds < ActiveRecord::Migration
  def change
    add_column :backgrounds, :bg_url, :string
  end
end
