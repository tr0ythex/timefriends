class AddAttachmentCustomBgToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :custom_bg
    end
  end

  def self.down
    remove_attachment :users, :custom_bg
  end
end
