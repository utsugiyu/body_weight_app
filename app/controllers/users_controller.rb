class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    @record = current_user.records.build

    if params[:duration] == "all"
      @graph_weights = @user.records.pluck(:weight)
      @graph_date = @user.records.pluck(:created_at).map{|date| date.strftime("%m/%d %R")}
    elsif params[:duration] == "3month"
      @graph_weights = @user.records.pluck(:weight).take(90)
      @graph_date = @user.records.pluck(:created_at).map{|date| date.strftime("%m/%d %R")}.take(90)
    elsif params[:duration] == "month"
      @graph_weights = @user.records.pluck(:weight).take(30)
      @graph_date = @user.records.pluck(:created_at).map{|date| date.strftime("%m/%d %R")}.take(30)
    else
      @graph_weights = @user.records.pluck(:weight).take(7)
      @graph_date = @user.records.pluck(:created_at).map{|date| date.strftime("%m/%d %R")}.take(7)
    end

    @graph_weights.reverse!
    @graph_date.reverse!
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:succes] = "The user was deleted"
    redirect_to login_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


    def correct_user
      @user = User.find_by(id: params[:id])
      unless current_user?(@user)
        flash[:danger] = "You are not authenticated"
        redirect_to(root_url)
      end
    end
end
