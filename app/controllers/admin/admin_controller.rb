class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @posts = Post.includes(:user, :comments).order(created_at: :desc)
    @users = User.includes(:posts, :comments).order(created_at: :desc)
    @comments = Comment.includes(:post, :user).order(created_at: :desc)
  end

  def show_post
    @post = Post.find(params[:id])
  end

  def destroy_post
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully deleted."
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
