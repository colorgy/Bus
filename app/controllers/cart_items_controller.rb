class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.cart_items
    @title = "購物車"
  end

  def create
    quantity_h = params[:quantity].reject{|k,v| v.empty?}
    schedules = Schedule.where(id: quantity_h.keys)

    begin
      ActiveRecord::Base.transaction do
        schedules.each do |schedule|
          current_user.add_to_cart!(schedule: schedule, quantity: quantity_h[schedule.id.to_s].to_i)
        end
      end
      flash[:success] = "成功加入購物車"
    rescue ActiveRecord::RecordInvalid
      # 基本不會發生，前端被亂改的時候
      flash[:error] = "不能坐太多哦"
    end

    redirect_to :back
  end

  def update_cart
    quantity_h = params[:schedule]
    Schedule.where(id: params[:schedule].keys).each do |schedule|
      current_user.add_to_cart!(schedule: schedule, quantity: quantity_h[schedule.id.to_s].to_i)
    end
    flash[:notice] = "購物車更新成功"
    redirect_to cart_items_path
  end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id]).destroy!
    flash[:success] = "成功從購物車中移除"
    redirect_to :back
  end
end
