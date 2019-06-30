class StaticPagesController < ApplicationController

  def home
    @user = current_user
    if logged_in?
      redirect_to "/users/#{@user.id}"
    else
      redirect_to "/login"
    end
  end
end
