class CartItemsController < ApplicationController


  def index
    if current_user.blank?
      flash[:error] = "請先登入才能進行此操作"
      redirect_to :back
    else
      @cart_items = current_user.cart_items
      @title = "購物車"
    end
  end

  def create
    if current_user.blank?
      flash[:error] = "請先登入才能進行此操作"
      redirect_to :back
    else
      schedule_id = params[:schedule][:id]
      schedule = Schedule.find_by(id: schedule_id)
      quantity = params[:schedule][:quantity].to_i

      user_cart_items = current_user.cart_items

      total_count = user_cart_items.map(&:quantity).sum + quantity

      if total_count > 3
        flash[:error] = "一次限購三張車票"
        redirect_to :back
      elsif !schedule.is_available?
        flash[:error] = "此班次不可取得"
        redirect_to :back
      elsif user_cart_items.count > 0 && !user_cart_items.pluck(:schedule_id).include?(schedule_id)
        flash[:error] = "一次限購一種班次，購物車已清空，請再加入一次"
        current_user.cart_items.destroy_all
        redirect_to :back
      else

        begin
          ActiveRecord::Base.transaction do
            current_user.add_to_cart!(schedule: schedule, quantity: quantity)
          end
          flash[:success] = "成功加入購物車"
        rescue ActiveRecord::RecordInvalid
          # 基本不會發生，前端被亂改的時候
          flash[:error] = "不能坐太多哦"
        end

        redirect_to :back
      end
    end
  end

  ## deprecated method
  def update_cart
    if current_user.blank?
      flash[:error] = "請先登入才能進行此操作"
      redirect_to :back
    else
      quantity_h = params[:schedule]
      total_count = Hash[ current_user.cart_items.map{|ci| [ci.schedule_id.to_s, ci.quantity.to_s] } ].merge(quantity_h).values.map(&:to_i).sum

      if total_count > 3
        flash[:error] = "一人限買三張車票"
        redirect_to :back
      else

        Schedule.where(id: params[:schedule].keys).each do |schedule|
          current_user.add_to_cart!(schedule: schedule, quantity: quantity_h[schedule.id.to_s].to_i)
        end
        flash[:notice] = "購物車更新成功"
        redirect_to cart_items_path
      end
    end
  end

  def destroy
    if current_user.blank?
      flash[:error] = "請先登入才能進行此操作"
      redirect_to :back
    else
      @cart_item = current_user.cart_items.find(params[:id]).destroy!
      flash[:success] = "成功從購物車中移除"
      redirect_to :back
    end
  end
end
