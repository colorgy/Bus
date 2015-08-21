class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def create
    if !params[:schedule]
      redirect_to routes_path
      flash[:error] = "您的購物車仍舊空空如也"
      return
    end

    @user_agreement = params[:user_agreement]

    quantity_h = params[:schedule]
    total_count = Hash[ current_user.cart_items.map{|ci| [ci.schedule_id.to_s, ci.quantity.to_s] } ].merge(quantity_h).values.map(&:to_i).sum

    if total_count > 3
      flash[:error] = "一人限買三張車票"
      redirect_to cart_items_path
    else

      Schedule.where(id: params[:schedule].keys).each do |schedule|
        current_user.add_to_cart!(schedule: schedule, quantity: quantity_h[schedule.id.to_s].to_i)
      end

      @cart_items = current_user.cart_items

      if params[:confirmed] && params[:user_agreement] == "on"
        # 從 create 到 confirm

        @data = current_user.checkout(bill_params, order_params)
        @bill = @data[:bill]
        @orders = @data[:orders]
        @order = @data[:orders].first
        @title = "最後確認訂單"

        render :confirm

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

        if params[:confirmed] && params[:user_agreement].nil?
          flash[:error] = "使用者條款未同意"
        end
      end
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
