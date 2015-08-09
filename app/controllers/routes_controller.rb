class RoutesController < ApplicationController

  def index
    @routes = Route.all
    @title = "路線瀏覽"
  end
end
