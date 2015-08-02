class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :registration_number
      t.integer :capacity
      t.text :description
      t.text :seat_info

      t.timestamps null: false
    end
  end
end
