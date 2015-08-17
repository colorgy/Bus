class AddParentIdToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :parent_id, :integer
  end
end
