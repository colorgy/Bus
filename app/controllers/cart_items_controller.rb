class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.cart_items
    @title = "購物車"
  end

  def create
    schedule = Schedule.find(params[:schedule_id])

    begin
      ActiveRecord::Base.transaction do
        params[:vehicle][:seats].reject(&:empty?).each do |seat_id|
          current_user.add_to_cart!(schedule: schedule, seat: Seat.find(seat_id))
        end
      end
      flash[:success] = "成功加入購物車"
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "不能重複座位"
    end

    redirect_to :back
  end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id]).destroy!
    flash[:success] = "成功從購物車中移除"
    redirect_to :back
  end
end
