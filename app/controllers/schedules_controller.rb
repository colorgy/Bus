class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule = Schedule.find_by_id(params[:id])

    if @schedule.nil?
      flash[:error] = "找不到班次 #{params[:id]}"
      redirect_to routes_path
    else
      @vehicle = @schedule.vehicle
      @title = @schedule.route.display_name
    end
  end
end
