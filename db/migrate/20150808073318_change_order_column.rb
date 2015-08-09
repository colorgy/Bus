class ChangeOrderColumn < ActiveRecord::Migration
  def change
    rename_column :orders, :seat_id, :seat_no
    change_column :orders, :seat_no, :string
  end
end
