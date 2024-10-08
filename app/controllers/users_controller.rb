class UsersController < ApplicationController

  before_action :authenticate_user, except: [:new, :create]

  before_action :require_correct_user, only: [:edit, :update, :show, :analytics]


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
    @user.x_username = @user.x_username.downcase if @user.x_username.present?
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
    @posts = Post.where(x_username: current_user.x_username)
    @user = current_user
  end

  def analytics
    @user = current_user
    @chats = @user.analytics_chats.order(created_at: :desc)
    @current_chat = if params[:chat_id]
                      @chats.find(params[:chat_id])
                    else
                      @chats.first || @user.analytics_chats.create!(chat_type: "Personal", prompt_temperature: 0.5, x_id: @user.x_id, x_username: @user.x_username)
                    end
    end


  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :x_username)
  end
end
