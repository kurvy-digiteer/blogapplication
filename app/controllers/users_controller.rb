class UsersController < ApplicationController
  before_action :set_user
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def profile
    @user.update(views: @user.views+1)
  end

  private
  def set_user
    @user = User.find_by!(name: params[:name])
  end

  def user_not_found
    flash[:alert] = "User not found"
    redirect_to root_path
  end
end
