class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def create
    quantity_h = params[:schedule]
    Schedule.where(id: params[:schedule].keys).each do |schedule|
      current_user.add_to_cart!(schedule: schedule, quantity: quantity_h[schedule.id.to_s].to_i)
    end

    @cart_items = current_user.cart_items

    if params[:confirmed]
      # TODOs: more exception handling here
      # @data = current_user.checkout!(bill_params, order_params)
      @data = current_user.checkout(bill_params, order_params)
      @bill = @data[:bill]
      @orders = @data[:orders]
      @order = @data[:orders].first
      @title = "最後確認訂單"
      render :confirm
      # redirect_to @data[:bill] and return if @data[:bill].id.present?
    elsif params[:last_confirmed]
      @data = current_user.checkout!(bill_params, order_params)
      redirect_to @data[:bill] and return if @data[:bill].id.present?
    elsif @cart_items.blank?
      redirect_to root_path and return
    else
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
