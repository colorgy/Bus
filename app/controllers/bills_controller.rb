class BillsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bills = current_user.bills
  end

  def show
    @bill = current_user.bills.find(params[:id])
    @orders = @bill.orders
  end
end
