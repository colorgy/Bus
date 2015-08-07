class AddDeletedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deleted_at, :datetime
    add_index  :orders, :deleted_at
    change_column :orders, :state, :string, :null => false
  end
end
