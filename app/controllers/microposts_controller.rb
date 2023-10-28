class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :current_user_micropost, only: %i(create)
  before_action :correct_user, only: %i(destroy)

  def create
    if @micropost.save
      flash[:success] = t("micropost_created")
      redirect_to root_path
    else
      @pagy, @feed_items = pagy current_user.feed.newest,
                                items: Settings.page_10
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("micropost_deleted")
    else
      flash[:danger] = t("delete_fail")
    end
    redirect_to request.referer || root_url
  end

  private
  def current_user_micropost
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params.dig(:micropost, :image)
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("micropost_invalid")
    redirect_to request.referer || root_url
  end
end
