class Admin::CommentsController < Admin::AdminController
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def index
    @comments = Comment.includes(:post, :user).order(created_at: :desc)
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
