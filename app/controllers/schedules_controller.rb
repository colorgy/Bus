class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule = Schedule.find_by_id(params[:id])

    if @schedule.nil?
      flash[:error] = "路線沒找到"
      redirect_to routes_path
    else
      @vehicle = @schedule.vehicle
    end
  end
end
