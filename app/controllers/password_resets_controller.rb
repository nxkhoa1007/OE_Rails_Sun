class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("send_email_reset_success")
      redirect_to root_path
    else
      flash.now[:danger] = t("email_not_found")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".error")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      @user.update_column :reset_digest, nil
      flash[:success] = t("reset_success")
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("account_not_activated")
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("account_not_activated")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = "Password reset has expired"
    redirect_to new_password_reset_url
  end
end
