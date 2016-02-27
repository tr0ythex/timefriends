class ChangeTypeOfAuthorColumnInComments < ActiveRecord::Migration
  def change
    change_column :comments, :author, 'integer USING CAST(author AS integer)'
  end
end