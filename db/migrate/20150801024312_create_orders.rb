class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :price
      t.integer :schedule_id
      t.integer :bill_id
      t.integer :vehicle_id
      t.integer :seat_id
      t.string :state

      t.timestamps null: false
    end

    add_index :orders, [:schedule_id, :bill_id, :vehicle_id, :seat_id], unique: true, name: :order_uniq_id
  end
end
