class RenameAuthorColumnInComments < ActiveRecord::Migration
  def change
    rename_column :comments, :author, :user_id
  end
end
