class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user
    redirect_to sign_in_path unless user_signed_in?
  end

  def require_correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, status: :see_other
    end
  end
end
