class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to static_pages_home_path
    end
  end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user.try(:authenticate, params.dig(:session, :password))
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status:422
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
