class RoutesController < ApplicationController
  before_action :authenticate_user!

  def index
    @routes = Route.all
  end
end
