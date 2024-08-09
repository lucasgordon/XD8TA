class HomeController < ApplicationController
  def index
    if current_user
      redirect_to analytics_user_path(current_user)
    else
      redirect_to sign_up_path
    end
  end
end
