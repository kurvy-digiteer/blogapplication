class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    @users = User.includes(:posts, :comments).order(created_at: :desc)
  end

  def edit
  end

  def update
    user_params = user_params()
    if user_params[:password].blank? 
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
  end
end
