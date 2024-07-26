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

  def fetch_posts
    twitter_api = XClient.new("1431612698836541440")
    result = twitter_api.fetch_and_save_tweets
    render plain: result
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :x_username)
  end
end
