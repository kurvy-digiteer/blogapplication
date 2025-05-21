class FeaturedController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user_or_customer!, except: %i[ show index]
  before_action :authorize_user_or_customer!, only: %i[ edit update destroy ]

  def index
    @filter = params[:filter]
    posts = @site.posts.where(feature: true, active: true).includes(:user, :customer)

    case @filter
    when "today"
      posts = posts.where(created_at: Date.today.all_day)
    when "this_week"
      posts = posts.where(created_at: Date.today.all_week)
    when "this_month"
      posts = posts.where(created_at: Date.today.all_month)
    end

    if params[:filter_date].present?
      begin
        date = Date.parse(params[:filter_date])
        posts = posts.where(created_at: date.all_day)
      rescue ArgumentError
        flash.now[:alert] = "Invalid date format"
      end
    end

    posts = posts.order(created_at: :desc)
    begin
      @pagy, @posts = pagy(posts, items: 5)
    rescue Pagy::OverflowError
      @pagy, @posts = pagy(posts, items: 5, page: 1)
      flash.now[:alert] = "Page #{params[:page]} does not exist. Showing page 1 instead."
    end
  end

  def show
    @post = @site.posts.where(feature: true, active: true).find_by!(permalink: params[:id])
    @post.update(views: @post.views + 1)
    @comments = @post.comments.order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to featured_path, alert: "Post not found."
  end

  # GET /posts/new
  def new
    @post = @site.posts.build(feature: true)
  end

  # GET /posts/1/edit
  def edit
    respond_to do |format|
      format.html { render partial: "featured/form", locals: { post: @post } }
    end
  end

  # POST /posts or /posts.json
  def create
    @post = @site.posts.build(post_params)
    if user_signed_in?
      @post.user = current_user
    else
      @post.customer = current_customer
    end
    @post.active = true
    @post.feature = true

    respond_to do |format|
      if @post.save
        format.html { redirect_to featured_index_path, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("form", partial: "featured/form", locals: { post: @post }),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { alert: @post.errors.full_messages.join(", ") })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params.merge(feature: true))
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              view_context.dom_id(@post),
              partial: "featured/show",
              locals: {
                post: @post,
                comments: @post.comments.order(created_at: :desc)
              }
            ),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { notice: "Post was successfully updated." })
          ]
        end
        format.html { redirect_to featured_path(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("form", partial: "featured/form", locals: { post: @post }),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { alert: @post.errors.full_messages.join(", ") })
          ]
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to featured_index_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = @site.posts.find_by!(permalink: params[:id])
  end

  def authenticate_user_or_customer!
    unless user_signed_in? || customer_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to continue."
    end
  end

  def authorize_user_or_customer!
    if user_signed_in?
      unless current_user == @post.user
        redirect_to featured_path, alert: "You are not authorized to perform this action."
      end
    elsif customer_signed_in?
      unless current_customer == @post.customer
        redirect_to featured_path, alert: "You are not authorized to perform this action."
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :active)
  end
end
