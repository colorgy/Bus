class RouteRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @route_request = RouteRequest.new
    route_id = params[:route_id]
    if route_id
      @route = Route.find_by(id: route_id)
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
