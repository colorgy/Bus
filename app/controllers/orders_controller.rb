class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to cart_items_path
  end

  def create
    if !params[:schedule]
      redirect_to routes_path
      flash[:error] = "您的購物車仍舊空空如也"
      return
    end

    @user_agreement = params[:user_agreement]
    @cart_items = current_user.cart_items

    if params[:confirmed] && params[:user_agreement] == "on"
      # 從 create 到 confirm

      @data = current_user.checkout(bill_params, order_params)
      @bill = @data[:bill]
      @orders = @data[:orders]
      @order = @data[:orders].first
      @title = "最後確認訂單"

      render :confirm

    elsif params[:confirmed] && params[:user_agreement] != "on"
      # 未同意，重填 create

      data = current_user.checkout
      @dup_orders = data[:dup_orders]
      @orders = data[:orders]
      @bill = data[:bill]
      @title = "確認訂位"
      flash[:error] = "使用者條款未同意"

    elsif params[:last_confirmed]
      # 從 confirm 到 建立訂單

      begin
        @data = current_user.checkout!(bill_params, order_params)
        redirect_to @data[:bill] and return if @data[:bill].id.present?
      rescue Exception => e
        Rails.logger.error e
        Rails.logger.error e.backtrace
        flash[:error] = "不好意思！有問題發生了，請您重新下訂"
        current_user.clear_cart!
        redirect_to routes_path
      end

    elsif @cart_items.blank?
      redirect_to root_path and return
    else
      # 從 cart_items 到 create
      data = current_user.checkout
      @dup_orders = data[:dup_orders]
      @orders = data[:orders]
      @bill = data[:bill]
      @title = "確認訂位"
    end
  end

  private

    def bill_params
      params.require(:bill).permit(:type, :invoice_type, :invoice_code, :invoice_cert, :invoice_love_code, :invoice_uni_num)
    end

    def order_params
      params.require(:order).permit(:receiver_name, :receiver_email, :receiver_phone, :receiver_identity_number)
    end
end
