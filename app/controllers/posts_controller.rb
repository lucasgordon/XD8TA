class PostsController < ApplicationController

  def show
    @x_username = params[:x_username]
    @analytic_chat = params[:analytic_chat]
    @posts = Post.where(x_username: @x_username)
  end
end
