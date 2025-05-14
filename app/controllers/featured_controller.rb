class FeaturedController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ show index]
  before_action :authorize_user!, only: %i[ edit update destroy ]
  def index
    @filter = params[:filter]
    @posts = Post.where(feature: true)

    case @filter
    when "today"
      @posts = @posts.where(created_at: Date.today.all_day)
    when "this_week"
      @posts = @posts.where(created_at: Date.today.all_week)
    when "this_month"
      @posts = @posts.where(created_at: Date.today.all_month)
    end

    if params[:filter_date].present?
      begin
        date = Date.parse(params[:filter_date])
        @posts = @posts.where(created_at: date.all_day)
      rescue ArgumentError
        flash.now[:alert] = "Invalid date format"
      end
    end

    @posts = @posts.order(created_at: :desc)
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

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.active = true
    @post.feature = true

    respond_to do |format|
      if @post.save
        format.html { redirect_to featured_index_path, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to featured_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
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
