class PagesController < ApplicationController
  def index
    if current_user
      redirect_to routes_path
    end
  end
end
