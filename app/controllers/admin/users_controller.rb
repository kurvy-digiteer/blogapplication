class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    sortable_columns = {
      "id" => "users.id",
      "name" => "users.name",
      "email" => "users.email",
      "posts_count" => "COUNT(DISTINCT posts.id)",
      "comments_count" => "COUNT(DISTINCT comments.id)",
      "created_at" => "users.created_at"
    }
    sort_column = sortable_columns[params[:sort]] || "users.id"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    users = @site.users.left_joins(:posts, :comments)
               .select("users.*, COUNT(DISTINCT posts.id) as posts_count, COUNT(DISTINCT comments.id) as comments_count")
               .group("users.id")
               .order(Arel.sql("#{sort_column} #{sort_direction}"))

    @pagy, @users = pagy(users, items: 10)
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
    @user = @site.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
  end
end
