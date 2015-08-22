class PagesController < ApplicationController
  def index
    if current_user
      redirect_to user_guide_path
    end
  end

  def user_guide

  end
end
