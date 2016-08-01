class AddIdenNumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iden_num, :string
    add_index :users, :iden_num, unique: true
  end
end
