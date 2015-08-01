class SchedulesController < ApplicationController
  def show
    @schedule = Schedule.find(params[:id])
  end
end
