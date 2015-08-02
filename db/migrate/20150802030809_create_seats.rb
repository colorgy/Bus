class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :vehicle_id
      t.integer :priority
      t.string :row_no
      t.string :seat_no


      t.timestamps null: false
    end
  end
end
