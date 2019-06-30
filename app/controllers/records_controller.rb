class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @user = current_user
    @record = current_user.records.build(record_params)

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
    
    if @record.save
      flash[:success] = "Record created!"
      redirect_to root_url
    else
      render 'users/show'
    end
  end

  def destroy
    @record.destroy
    flash[:success] = "Record deleted"
    redirect_to request.referrer || root_url
  end



  private
  def record_params
    params.require(:record).permit(:weight)
  end

  def correct_user
      @record = current_user.records.find_by(id: params[:id])
      redirect_to root_url if @record.nil?
  end
end
