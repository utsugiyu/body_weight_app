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

  def oauth
    client = OAuth2::Client.new(ENV["API_ID"], ENV["API_SECRET"], :site => 'https://www.healthplanet.jp', :authorize_url => ' https://www.healthplanet.jp/oauth/auth',
              :token_url => 'https://www.healthplanet.jp/oauth/token')
    redirect_uri = 'https://body-w.herokuapp.com/users/callback'
    authorize_url = "https://www.healthplanet.jp/oauth/auth?client_id=#{ENV["API_ID"]}&redirect_uri=#{redirect_uri}&scope=innerscan&response_type=code"
    redirect_to authorize_url
  end

  def callback
    client = OAuth2::Client.new(ENV["API_ID"], ENV["API_SECRET"],
    {
      site: 'https://www.healthplanet.jp/',
      token_url: 'oauth/token',
    }
    )
    token = client.auth_code.get_token(
    params[:code],
    {:redirect_uri => 'https://body-w.herokuapp.com/users/callback',
    :grant_type => "authorization_code"}
    )

    access_token = token.token
    refresh_token = token.refresh_token

    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    encrypt_access_token = encryptor.encrypt_and_sign(access_token)
    encrypt_refresh_token = encryptor.encrypt_and_sign(refresh_token)
    current_user.update_attributes(access_token: encrypt_access_token, refresh_token: encrypt_refresh_token)

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
