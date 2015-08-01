class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.integer :capacity
      t.text :description
      t.text :seat_info

      t.timestamps null: false
    end
  end
end
