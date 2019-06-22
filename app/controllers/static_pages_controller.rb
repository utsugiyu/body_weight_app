class StaticPagesController < ApplicationController

  def home
    if logged_in?
    else
      redirect_to "/login"
    end
  end
end
