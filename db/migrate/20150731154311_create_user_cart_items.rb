class CreateUserCartItems < ActiveRecord::Migration
  def change
    create_table :user_cart_items do |t|
      t.integer :user_id
      t.integer :route_id
      t.integer :schedule_id
      t.integer :seat_id
      t.integer :price

      t.timestamps null: false
    end

    add_index :user_cart_items, [:user_id, :seat_id, :schedule_id], unique: true
  end
end
