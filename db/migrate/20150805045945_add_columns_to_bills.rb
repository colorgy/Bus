class AddColumnsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :uuid, :string
    add_column :bills, :type, :string

    change_column_null :bills, :uuid, false
    change_column_null :bills, :type, false
    change_column_null :bills, :price, false
    change_column_null :bills, :user_id, false
    change_column_null :bills, :amount, false
    change_column_null :bills, :invoice_type, false

    rename_column :bills, :user_credits, :used_credits
    change_column_null :bills, :used_credits, false
    change_column_default :bills, :used_credits, 0
  end
end
