class DropInvitedFriends < ActiveRecord::Migration
  def change
    drop_table :invited_friends
    # remove_index(:invited_friends, :name => 'index_invited_friends_on_post_id')
    # remove_index(:invited_friends, :name => 'index_invited_friends_on_user_id')
  end
end
