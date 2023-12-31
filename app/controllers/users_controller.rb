class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sort_by_name, items: Settings.page_10
  end

  def new
    @user = User.new
    if logged_in?
      redirect_to static_pages_home_path
    elsif @user.save
      log_in @user
      redirect_to static_pages_home_path
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("not_found_user")
    redirect_to root_path
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:success] = t("created_successful")
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by id: params[:id]
    @page, @microposts = pagy @user.microposts.newest, items: Settings.page_10
    return if @user

    flash.now[:warning] = t("not_found_user")
    redirect_to root_path
  end

  def update
    if @user.update user_params
      flash[:success] = t("update_successful")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:danger] = t("delete_fail!")
    end
    redirect_to users_path
  end

  def following
    @title = t("following")
    @pagy, @users = pagy @user.following, items: Settings.page_10
    render :show_follow
  end

  def followers
    @title = t("followers")
    @pagy, @users = pagy @user.followers, items: Settings.page_10
    render :show_follow
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email,
                  :password, :password_confirmation,
                  :dob, :gender
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("not_found_user")
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:warning] = t("cannot_edit")
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
