class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @posts = Post.includes(:user, :comments).order(created_at: :desc)
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
