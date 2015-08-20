class RoutesController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def index
    if params[:root_route]
      @root_route = Route.root.find_by(id: params[:root_route])

      if @root_route.present?
        # The 支線
        @routes = @root_route.subroutes
        @title = @root_route.short_name
        @h4 = "從 #{@root_route.display_name} 的所有支線"
        render :subroutes
      else
        @route = Route.find_by(id: params[:root_route])
        if @route.present? && @route.parent.present?
          # it's subroute
          redirect_to route_path(@route)
        end
      end
    else
      @routes = Route.root.order(:direction)
      @title = "路線總覽"
    end
  end

  def show
    @route = Route.find_by(id: params[:id])

    if @route.nil?
      flash[:error] = "路線錯誤！"
      redirect_to root_path
    elsif @route.parent.nil?
      # it's a root route
      redirect_to routes_path, root_route: @route.id
    else
      @title = @route.short_name
      @root_route = @route.parent
    end
  end
end
