class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def create
    @user = User.new(user_params)
    @user.save!
    redirect_to root_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update!(user_params)
    redirect_to root_path
  end

  def initiate_fetch
    x_service = XClient.new(current_user)
    request_token = x_service.get_request_token
    x_service.get_user_authorization(request_token)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    @auth_url = x_service.authorization_url

    render :authorize  # Render a view that shows the authorization URL and a form for the PIN
  end

  def fetch_posts
    debugger
    request_token = OAuth::RequestToken.new(
      XClient.new(current_user).consumer,
      session[:request_token],
      session[:request_token_secret]
    )
    pin = params[:pin]  # Assume the PIN is submitted by the user in a form
    x_service = XClient.new(current_user)
    x_service.obtain_access_token(request_token, pin)
    x_service.fetch_tweets

    redirect_to users_path(current_user), notice: "Tweets fetched successfully."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :x_username)
  end
end
