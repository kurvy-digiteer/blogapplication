class Admin::PostsController < Admin::AdminController
  # Helper for sorting posts is already in the admin controller
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  helper_method :calendar_view?

  def index
    super
    sortable_columns = %w[id title views likes_count created_at feature active]
    sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "id"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    posts_scope = Post.includes(:user, :customer, :comments).order("#{sort_column} #{sort_direction}")

    if params[:all_time].present?
      # When all_time is present, use regular pagination without any date filtering
      @pagy, @posts = pagy(posts_scope, items: 10)
      @pagy_calendar = nil
    else
      # Pagy calendar for month navigation
      calendar_params = params.slice(:year, :month, :quarter, :week, :day).to_unsafe_h.symbolize_keys

      # Configure calendar options
      calendar_options = {
        year: {
          format: "%Y",
          link_extra: 'class="btn btn-outline-primary mx-1"',
          params: { all_time: nil, page: nil }
        },
        month: {
          format: "%B",  # Full month name (e.g., "May")
          link_extra: 'class="btn btn-outline-primary mx-1"',
          order: :desc,
          params: { all_time: nil, page: nil, month_page: nil }
        }
      }

      # Use calendar pagination
      @pagy_calendar, @pagy, @posts = pagy_calendar(
        posts_scope,
        **calendar_options,
        pagy: { items: 10 }
      )
    end
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

  # Required by pagy_calendar
  def pagy_calendar_period(collection)
    # Get the first and last post dates
    first_post = collection.reorder(:created_at).first
    last_post = collection.reorder(created_at: :desc).first

    return [ Time.current.beginning_of_month, Time.current.end_of_month ] unless first_post && last_post

    [ first_post.created_at.beginning_of_month, last_post.created_at.end_of_month ]
  end

  # Required by pagy_calendar
  def pagy_calendar_filter(collection, from, to)
    collection.where(created_at: from...to)  # 3-dots range excluding the end value
  end

  def calendar_view?
    params[:year].present? || params[:month].present?
  end
end
