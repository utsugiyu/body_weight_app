class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @user = current_user
    @record = current_user.records.build(record_params)
    @records = @user.records.page(params[:page]).per(7)

    if params[:duration] == "all"
      @graph_weights = @user.records.pluck(:weight)
      @graph_date = @user.records.pluck(:created_at).map{|date| date.strftime("%-m/%-d %k:%M")}
    elsif params[:duration] == "month"
      from = Time.zone.now - 720.hour
      to = Time.zone.now
      @graph_weights = @user.records.where(created_at: from..to).pluck(:weight)
      @graph_date = @user.records.where(created_at: from..to).pluck(:created_at).map{|date| date.strftime("%-m/%-d %k:%M")}
    elsif params[:duration] == "week"
      from = Time.zone.now - 168.hour
      to = Time.zone.now
      @graph_weights = @user.records.where(created_at: from..to).pluck(:weight)
      @graph_date = @user.records.where(created_at: from..to).pluck(:created_at).map{|date| date.strftime("%-m/%-d %k:%M")}
    else
      from = Time.zone.now - 72.hour
      to = Time.zone.now
      @graph_weights = @user.records.where(created_at: from..to).pluck(:weight)
      @graph_date = @user.records.where(created_at: from..to).pluck(:created_at).map{|date| date.strftime("%-m/%-d %k:%M")}
    end

    @graph_weights.reverse!
    @graph_date.reverse!

    if @record.save
      flash[:success] = "Record created!"
      redirect_to "/users/#{@user.id}?duration=#{params[:duration]}"
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
