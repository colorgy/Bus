class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :price
      t.integer :amount
      t.integer :invoice_id
      t.string :invoice_type
      t.text :invoice_data
      t.text :data
      t.string :state
      t.string :payment_code
      t.datetime :paid_at
      t.integer :user_credits
      t.datetime :deadline
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
