class AddOrdersCountToBills < ActiveRecord::Migration
  def change
    add_column :bills, :orders_count, :integer

    Bill.pluck(:id).each do |i|
      Bill.reset_counters(i, :orders) # 全部重算一次
    end
  end
end
