class Admin::AdminController < ApplicationController
  include Admin::SortableHelper

  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @posts = @site.posts.includes(:user, :customer, :comments).order(created_at: :desc)
    @users = @site.users.includes(:posts, :comments).order(created_at: :desc)
    @customers = @site.customers.includes(:posts, :comments).order(created_at: :desc)
    @comments = @site.comments.includes(:post, :user, :customer).order(created_at: :desc)
  end

  def show_post
    @post = @site.posts.find(params[:id])
  end

  def destroy_post
    @post = @site.posts.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully deleted."
  end

  private

  def authenticate_user_or_customer!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to continue."
    end
  end

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
