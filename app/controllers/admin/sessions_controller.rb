class Admin::SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  before_action :require_admin

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  private

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end
end
