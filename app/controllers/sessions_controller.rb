class SessionsController < ApplicationController
  def new
    return unless logged_in?

    redirect_to static_pages_home_path
  end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params[:session][:password])
      check_activated_user user
    else
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def check_activated_user user
    if user.activated
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || root_path
    else
      flash[:warning] = t("account_not_activated")
      render :new, status: :unprocessable_entity
    end
  end
end
