class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :departure_time, null: false
      t.integer :route_id
      t.string :contact
      t.integer :vehicle_id

      t.timestamps null: false
    end
  end
end
