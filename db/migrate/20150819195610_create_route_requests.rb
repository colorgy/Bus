class CreateRouteRequests < ActiveRecord::Migration
  def change
    create_table :route_requests do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.integer :user_id, null: false
      t.integer :route_id
      t.string :request_origin
      t.string :request_destination
      t.text   :message

      t.timestamps null: false
    end
  end
end
