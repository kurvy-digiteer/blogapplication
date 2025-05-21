class UsersController < ApplicationController
  before_action :set_user

  def profile
    @user = @site.users.find_by!(name: params[:name])
    @user.update(views: @user.views+1)
  end

  private
  def set_user
    @user = User.find_by!(name: params[:name])
  end
end
