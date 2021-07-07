class AddPvcountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :pvcount, :integer
  end
end
