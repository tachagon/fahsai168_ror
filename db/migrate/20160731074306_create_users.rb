class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :member_code
      t.string :password_digest
      t.string :f_name
      t.string :l_name
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :email
      t.string :phone
      t.string :line
      t.string :role
      t.references :position, index: true, foreign_key: true
      t.string :remember_digest

      t.timestamps null: false
    end
    add_index :users, :member_code, unique: true
  end
end
