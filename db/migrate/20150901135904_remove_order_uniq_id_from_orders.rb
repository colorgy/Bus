class RemoveOrderUniqIdFromOrders < ActiveRecord::Migration
  def change
    remove_index :orders, name: :order_uniq_id
  end
end
