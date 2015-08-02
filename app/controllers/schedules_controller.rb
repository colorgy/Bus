class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedule = Schedule.find_by_id(params[:id])

    # TODO: add flash message route not found
    if @schedule.nil?
      redirect_to routes_path
    else
      @vehicle = @schedule.vehicle
    end
  end
end
