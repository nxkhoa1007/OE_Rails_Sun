class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: %i(create)
  before_action :load_relationship, only: %i(destroy)

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("follow_form", partial: "users/unfollow"),
          turbo_stream.update("followers", @user.followers.count)
        ]
      end
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("follow_form", partial: "users/follow"),
          turbo_stream.update("followers", @user.followers.count)
        ]
      end
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t("not_found_user")
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:danger] = t("not_found_relationship")
    redirect_to root_path
  end
end
