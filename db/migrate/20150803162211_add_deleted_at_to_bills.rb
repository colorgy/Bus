class AddDeletedAtToBills < ActiveRecord::Migration
  def change
    add_column :bills, :deleted_at, :datetime
    add_index  :bills, :deleted_at
    change_column :bills, :state, :string, :null => false
  end
end
