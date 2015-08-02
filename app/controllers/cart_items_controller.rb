class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.cart_items
  end

  def create
    schedule = Schedule.find(params[:schedule_id])

    begin
      ActiveRecord::Base.transaction do
        params[:vehicle][:seats].reject(&:empty?).each do |seat_id|
          current_user.add_to_cart!(schedule: schedule, seat: Seat.find(seat_id))
        end
      end
    rescue ActiveRecord::RecordNotUnique
      # flash message
    end

    redirect_to :back
  end
end
