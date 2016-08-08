class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :sponser_id
      t.integer :sponsered_id

      t.timestamps null: false
    end
    add_index :relations, :sponser_id
    add_index :relations, :sponsered_id
    add_index :relations, [:sponser_id, :sponsered_id], unique: true
  end
end
