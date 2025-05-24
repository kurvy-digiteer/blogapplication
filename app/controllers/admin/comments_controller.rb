class Admin::CommentsController < Admin::AdminController
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def index
    @q = Comment.includes(:post, :user, :customer)
                .joins("LEFT JOIN posts ON posts.id = comments.post_id")
                .joins("LEFT JOIN users ON users.id = comments.user_id")
                .joins("LEFT JOIN customers ON customers.id = comments.customer_id")
                .ransack(params[:q])

    comments = @q.result
                .select("comments.*, posts.title as post_title,
                        CASE
                          WHEN users.id IS NOT NULL THEN users.name
                          WHEN customers.id IS NOT NULL THEN customers.name
                          ELSE NULL
                        END as author_name")

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
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
