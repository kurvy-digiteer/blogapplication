class Admin::CommentsController < Admin::AdminController
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def index
    sortable_columns = {
      "id" => "comments.id",
      "title" => "posts.title",
      "name" => "COALESCE(users.name, customers.name)",
      "body" => "action_text_rich_texts.body",
      "created_at" => "comments.created_at"
    }
    sort_param = params[:sort] || "id"
    sort_column = sortable_columns[sort_param] || "comments.id"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    comments = @site.comments
      .left_joins(:post)
      .left_joins(:user)
      .left_joins(:customer)
      .joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_type = 'Comment'
        AND action_text_rich_texts.record_id = comments.id AND action_text_rich_texts.name = 'body'")
      .select("comments.*, posts.title as post_title, COALESCE(users.name, customers.name) as author_name")
      .order(Arel.sql("#{sort_column} #{sort_direction}"))

    @pagy, @comments = pagy(comments, items: 10)
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to admin_post_path(@comment.post), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = @comment.post
    @comment.destroy
    redirect_to admin_post_path(post), notice: "Comment was successfully deleted."
  end

  private

  def set_comment
    @comment = @site.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
