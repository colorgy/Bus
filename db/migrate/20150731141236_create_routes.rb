class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :origin
      t.string :destination
      t.string :direction
      t.integer :price
      t.text :description
      t.text :announcement
      t.string :route_map_url

      t.timestamps null: false
    end
  end
end
