class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  def posts
    @posts = @site.posts.includes(:user, :comments)
  end

  def comments
  end

  def users
  end

  def show_post
    @post = @site.posts.includes(:user, :comments).find(params[:id])
  end

  def destroy_post
    @post = @site.posts.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
