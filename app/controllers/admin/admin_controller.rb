class Admin::AdminController < ApplicationController
  include Admin::SortableHelper
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :require_admin

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

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end

  def apply_search(scope, search_term)
    return scope unless search_term.present?

    case scope.name
    when "Post"
      scope.ransack(
        title_or_user_name_or_user_email_or_customer_name_or_customer_email_cont_any: search_term
      ).result(distinct: true)
    when "User"
      scope.ransack(
        name_or_email_cont_any: search_term
      ).result(distinct: true)
    when "Customer"
      scope.ransack(
        name_or_email_cont_any: search_term
      ).result(distinct: true)
    when "Comment"
      scope.ransack(
        body_or_user_name_or_customer_name_cont_any: search_term
      ).result(distinct: true)
    else
      scope
    end
  end
end
