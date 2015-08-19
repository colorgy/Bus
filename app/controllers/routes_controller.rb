class RoutesController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def index
    @routes = Route.root.order(:direction)
    @title = "路線總覽"
  end

  def show
    @route = Route.find_by(id: params[:id])

    if @route.nil? || @route.parent.present?
      flash[:error] = "路線錯誤！"
      redirect_to root_path
    end

    @title = @route.short_name
  end
end
