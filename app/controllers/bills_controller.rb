class BillsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bills = current_user.bills
    @title = "我的票卷"
  end

  def show
    @bill = current_user.bills.find(params[:id])
    @orders = @bill.orders
    @title = "檢視票卷"
  end
end
