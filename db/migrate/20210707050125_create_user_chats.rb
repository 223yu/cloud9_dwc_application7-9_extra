class CreateUserChats < ActiveRecord::Migration[5.2]
  def change
    create_table :user_chats do |t|
      t.integer :send_user_id
      t.integer :receive_user_id
      t.string :content

      t.timestamps
    end
    add_index :user_chats, :send_user_id
    add_index :user_chats, :receive_user_id
    add_index :user_chats, [:send_user_id, :receive_user_id], unique: true
  end
end
