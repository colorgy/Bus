class CreateUserCartItems < ActiveRecord::Migration
  def change
    create_table :user_cart_items do |t|
      t.integer :user_id
      t.integer :schedule_id
      t.integer :route_id

      t.timestamps null: false
    end
  end
end
