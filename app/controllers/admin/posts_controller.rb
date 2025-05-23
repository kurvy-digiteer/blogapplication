class Admin::PostsController < Admin::AdminController
  # Helper for sorting posts is already in the admin controller
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  helper_method :calendar_view?

  def index
    @q = Post.includes(:user, :customer).ransack(params[:q])
    posts = @q.result

    # Apply search if present
    if params[:q_all].present?
      # Ransack for title and user/customer fields
      posts = Post.ransack(
        title_or_user_email_or_user_name_or_customer_email_or_customer_name_cont_any: params[:q_all]
      ).result(distinct: true)
    end

    if params[:all_time].present?
      # Show all posts if all_time is selected
      @pagy, @posts = pagy(posts, items: 10)
      @pagy_calendar = nil
      @months_with_posts = []
    else
      # Pagy calendar for month navigation
      calendar_params = params.slice(:year, :month, :quarter, :week, :day).to_unsafe_h.symbolize_keys

      # Find dynamic year range from filtered posts
      min_year = posts.minimum(:created_at)&.year || 2022
      max_year = posts.maximum(:created_at)&.year || 2025
      posts = posts.between_years(min_year, max_year)

      # Only filter by year/month if those params are present
      if params[:year].present? || params[:month].present?
        # pagy_calendar will handle the filtering
      end

      # Find months with posts
      @months_with_posts = posts
        .group(Arel.sql("EXTRACT(YEAR FROM posts.created_at)"), Arel.sql("EXTRACT(MONTH FROM posts.created_at)"))
        .pluck(Arel.sql("EXTRACT(YEAR FROM posts.created_at)::int"), Arel.sql("EXTRACT(MONTH FROM posts.created_at)::int"))

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
        posts,
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
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully deleted."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by!(permalink: params[:id])
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
    params.require(:post).permit(:title, :body, :feature, :active)
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
