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

    if params[:user_agreement].present? && params[:user_agreement] == "on"

      if params[:confirmed]
        @data = current_user.checkout(bill_params, order_params)
        @bill = @data[:bill]
        @orders = @data[:orders]
        @order = @data[:orders].first
        @title = "最後確認訂單"

        render :confirm

      elsif params[:last_confirmed]
        # TODOs: more exception handling here
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
        data = current_user.checkout
        @dup_orders = data[:dup_orders]
        @orders = data[:orders]
        @bill = data[:bill]
        @title = "確認訂位"
      end

    else # user not check the agreement
      flash[:error] = "使用者條款未同意"
      redirect_to cart_items_path
    end
  end

  def agreement
    @title = "使用者條款"
    @cart_items = current_user.cart_items
    render :user_agreement
  end


  private

    def bill_params
      params.require(:bill).permit(:type, :invoice_type, :invoice_code, :invoice_cert, :invoice_love_code, :invoice_uni_num)
    end

    def order_params
      params.require(:order).permit(:receiver_name, :receiver_email, :receiver_phone, :receiver_identity_number)
    end
end
