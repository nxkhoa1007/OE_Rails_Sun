class UsersController < ApplicationController
  def new
    @user = User.new
    if logged_in?
      redirect_to static_pages_home_path
    end
    if @user.save
      login @user
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      login @user
      flash[:success] = t "created_successfull"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "not_found_user"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation, :dob, :gender)
  end
end
