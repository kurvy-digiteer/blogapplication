class Admin::PostsController < Admin::AdminController
  # Helper for sorting posts
  helper Admin::SortableHelper
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  def index
    super
    sortable_columns = %w[id title views likes_count created_at feature active]
    sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "id"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"
    @posts = Post.includes(:user, :customer, :comments).order("#{sort_column} #{sort_direction}")
  end

  def show
    @post.update(views: @post.views + 1)
    @comments = @post.comments.order(created_at: :desc)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to admin_post_path(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: [ :admin, @post ] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_path, notice: "Post was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to admin_posts_path, alert: "Post not found." }
      format.json { render json: { error: "Post not found" }, status: :not_found }
    end
  end

  def authorize_user!
    unless current_user == @post.user || current_user.admin?
      redirect_to featured_path, alert: "You are not authorized to perform this action."
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :active, :feature)
  end
end
