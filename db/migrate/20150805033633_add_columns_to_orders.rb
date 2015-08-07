class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :receiver_name, :string
    add_column :orders, :receiver_email, :string
    add_column :orders, :receiver_phone, :string
    add_column :orders, :receiver_identity_number, :string

   change_column_null :orders, :receiver_name, false
   change_column_null :orders, :receiver_identity_number, false
  end
end
