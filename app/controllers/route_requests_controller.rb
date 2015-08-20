class RouteRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    quantity_h = params[:schedule]
    total_count = Hash[ current_user.cart_items.map{|ci| [ci.schedule_id.to_s, ci.quantity.to_s] } ].merge(quantity_h).values.map(&:to_i).sum
    asdf
    if total_count > 3
      flash[:error] = "一人限買三張車票"
      redirect_to cart_items_path
    else

      @route_request = RouteRequest.new
      route_id = params[:route_id]
      if route_id
        @route = Route.find_by(id: route_id)
      end
    end
  end

  def create
    @route_request = RouteRequest.create(request_params.merge({user: current_user}))
    if @route_request
      render :success
    else
      redirect_to :back
    end
  end

  private
    def request_params
      params.require(:route_request).permit(:name, :email, :phone_number, :route_id, :request_origin, :request_destination, :message)
    end
end
