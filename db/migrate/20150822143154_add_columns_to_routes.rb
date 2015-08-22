class AddColumnsToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :is_available, :boolean, default: false
    add_column :routes, :hidden, :boolean, default: true
    add_column :routes, :fake_full, :boolean, default: false

    Route.all.each do |route|
      route.is_available = true
      route.hidden = false
      route.fake_full = false
      route.save!
    end
  end
end
