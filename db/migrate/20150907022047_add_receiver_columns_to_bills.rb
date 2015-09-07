class AddReceiverColumnsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :receiver_name, :string
    add_column :bills, :receiver_email, :string
    add_column :bills, :receiver_phone, :string
    add_column :bills, :receiver_identity_number, :string

    Bill.all.each do |bill|
      bill.receiver_name = bill.orders.first.receiver_name
      bill.receiver_email = bill.orders.first.receiver_email
      bill.receiver_phone = bill.orders.first.receiver_phone
      bill.receiver_identity_number = bill.orders.first.receiver_identity_number

      bill.save!
    end

    remove_column :orders, :receiver_name
    remove_column :orders, :receiver_email
    remove_column :orders, :receiver_phone
    remove_column :orders, :receiver_identity_number
  end
end
