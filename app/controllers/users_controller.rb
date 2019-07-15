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

  def token
    require 'net/http'
    request_token = params[:code]

    uri = URI.parse("https://www.healthplanet.jp/oauth/token")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({'client_id' => ENV["API_ID"], 'client_secret' => ENV["API_SECRET"],
       'redirect_uri' => 'https://body-w.herokuapp.com/users/callback', 'code' => request_token, 'grant_type' => 'authorization_code' })

    res = http.request(req)

  end

  def callback
    redirect_to "/users/#{current_user.id}"
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
