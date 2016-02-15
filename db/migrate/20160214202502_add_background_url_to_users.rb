class AddBackgroundUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :background_url, :string
  end
end
