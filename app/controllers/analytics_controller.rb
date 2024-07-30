class AnalyticsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @posts = @user.posts
  end
end
