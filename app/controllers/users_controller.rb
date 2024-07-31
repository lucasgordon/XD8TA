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
    @user.email = @user.email.downcase if @user.email.present?
    @user.save!
    session[:user_id] = @user.id
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

  def posts
    @posts = current_user.posts
  end

  def fetch_posts_private_metrics
    twitter_api = XClient.new(current_user)
    result = twitter_api.fetch_private_metrics
    redirect_to posts_user_path(current_user)
  end

  def fetch_posts_public_metrics
    twitter_api = XClient.new(current_user)
    result = twitter_api.fetch_public_metrics
    redirect_to posts_user_path(current_user)
  end

  def analytics
    @user = current_user
    @analytics = @user.analytics
  end

  def generate_analytics
    @user = current_user
    @user.generate_analytics
    redirect_to analytics_user_path(current_user)
  end

  def regenerate_analytics
    @user = current_user
    @user.analytics.destroy_all
    @user.generate_analytics
    redirect_to analytics_user_path(current_user)
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :x_username)
  end
end
