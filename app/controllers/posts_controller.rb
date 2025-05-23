class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user_or_customer!, except: %i[ show index]
  before_action :authorize_user_or_customer!, only: %i[ edit update destroy ]

  def index
    @filter = params[:filter]
    posts = Post.where(active: true).includes(:user, :customer)

    case @filter
    when "today"
      posts = posts.where(created_at: Date.today.all_day)
    when "this_week"
      posts = posts.where(created_at: Date.today.all_week)
    when "this_month"
      posts = posts.where(created_at: Date.today.all_month)
    when "featured"
      posts = posts.where(feature: true)
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
    @pagy, @posts = pagy(posts)
  end

  def show
    @post.update(views: @post.views + 1)
    @comments = @post.comments.order(created_at: :desc)

    # This is useful if you only want to update a specific part of the page with turbo_frame_tag
    # and not the entire page, like in this case we only want to update the post body
    # without this, the entire page would be updated, and we would lose the post body.
    # This is useful for toggling using turbo without using javascript or other libraries.
    # But using javascript is probably better for this use case to keep things simple.
    if turbo_frame_request?
      render html: view_context.turbo_frame_tag("post_#{@post.id}_body") {
        view_context.render(partial: "posts/post_body", locals: { post: @post, expanded: params[:read_more].present? })
      }.html_safe
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    respond_to do |format|
      format.html { render partial: "posts/form", locals: { post: @post } }
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    if user_signed_in?
      @post.user = current_user
    else
      @post.customer = current_customer
    end
    @post.active = true

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("form", partial: "posts/form", locals: { post: @post }),
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
      if @post.update(post_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
            view_context.dom_id(@post),
            partial: "posts/show",
            locals: {
              post: @post,
              comments: @post.comments.order(created_at: :desc) }),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { notice: "Post was successfully updated." })
            ]
        end
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("form", partial: "posts/form", locals: { post: @post }),
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
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Find post by permalink, find_by! will raise an ActiveRecord error not found
    # only use find_by if you are sure the record will exist and you have a custom
    # action to do if it doesn't exist as find_by! will just raise an error
    def set_post
      @post = Post.find_by!(permalink: params[:id])
    end

    def authenticate_user_or_customer!
      unless user_signed_in? || customer_signed_in?
        redirect_to new_user_session_path, alert: "Please sign in to continue."
      end
    end

    def authorize_user_or_customer!
      if user_signed_in?
        unless current_user == @post.user
          redirect_to posts_path, alert: "You are not authorized to perform this action."
        end
      elsif customer_signed_in?
        unless current_customer == @post.customer
          redirect_to posts_path, alert: "You are not authorized to perform this action."
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :active, :feature)
    end
end
