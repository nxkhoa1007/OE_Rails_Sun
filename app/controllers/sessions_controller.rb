class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to static_pages_home_path
    end
  end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        flash[:warning] = t("account_not_activated")
        render :new, status:422
      end
    else
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new, status:422
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
