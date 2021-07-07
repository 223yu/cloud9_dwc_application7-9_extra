class RemoveindexFromUserChat < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_chats, name: :index_user_chats_on_send_user_id_and_receive_user_id
  end
end
