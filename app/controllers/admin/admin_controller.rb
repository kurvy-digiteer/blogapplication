class Admin::AdminController < ApplicationController
  include Admin::SortableHelper

  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @posts = Post.includes(:user, :customer, :comments).order(created_at: :desc)
    @users = User.includes(:posts, :comments).order(created_at: :desc)
    @customers = Customer.includes(:posts, :comments).order(created_at: :desc)
    @comments = Comment.includes(:post, :user, :customer).order(created_at: :desc)
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
