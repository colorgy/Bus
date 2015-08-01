class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :price
      t.integer :schedule_id
      t.integer :bill_id
      t.string :state

      t.timestamps null: false
    end
  end
end
