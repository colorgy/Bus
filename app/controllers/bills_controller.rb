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

  def credit_card_callback
    if params[:OrderNO]
      @bill = Bill.find_by(uuid: params[:OrderNO])
    end

    if params[:Status] == 'S'
      flash[:success] = "信用卡付款成功！"
      @bill.pay_if_paid!
    else
      flash[:alert] = "信用卡授權失敗！"
    end

    redirect_to bill_path(@bill)
  end
end
