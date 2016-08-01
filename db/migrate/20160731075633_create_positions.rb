class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name
      t.integer :layer
      t.integer :min_pv

      t.timestamps null: false
    end
    add_index :positions, :name, unique: true
  end
end
