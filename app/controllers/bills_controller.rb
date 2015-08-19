class BillsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bills = current_user.bills
    @title = "我的帳單"
  end

  def show
    @bill = current_user.bills.find(params[:id])
    @orders = @bill.orders
    @title = "檢視帳單"
  end
end
