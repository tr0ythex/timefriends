class ChangeTypeOfAuthorColumnInComments < ActiveRecord::Migration
  def change
    change_column :comments, :author, :integer
  end
end
