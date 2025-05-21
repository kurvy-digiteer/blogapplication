class CommentsController < ApplicationController
    before_action :authenticate_user_or_customer!
    before_action :set_post
    before_action :set_comment, only: [ :edit, :update, :destroy ]

    def create
        @comment = @post.comments.build(comment_params)
        @comment.site = @site
        @comment.user = current_user if user_signed_in?
        @comment.customer = current_customer if customer_signed_in?

        respond_to do |format|
            if @comment.save
                format.turbo_stream do
                    render turbo_stream: [
                        turbo_stream.update("new_comment", partial: "comments/form", locals: { post: @post, comment: @post.comments.build, submit_label: "Reply" }),
                        turbo_stream.prepend("comments", partial: "comments/comments", locals: { comments: @post.comments, post: @post }),
                        turbo_stream.update("notice", partial: "layouts/alerts", locals: { notice: "Your comment has been created" })
                    ]
                end
                format.html { redirect_to parent_post_path(@post), notice: "Your comment has been created" }
            else
                format.turbo_stream do
                    render turbo_stream: turbo_stream.update("notice", partial: "layouts/alerts", locals: { alert: "YOUR COMMENT WAS NOT CREATED" })
                end
                format.html { redirect_to parent_post_path(@post), alert: "YOUR COMMENT WAS NOT CREATED" }
            end
        end
    end

    def destroy
        @comment = @post.comments.find(params[:id])
        if user_signed_in?
            unless current_user == @comment.user || current_user.admin?
                redirect_to parent_post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        elsif customer_signed_in?
            unless current_customer == @comment.customer
                redirect_to parent_post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        end

        @comment.destroy
        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: [
                turbo_stream.remove(view_context.dom_id(@comment)),
                turbo_stream.update("notice", partial: "layouts/alerts", locals: { alert: "Your comment has been deleted" })
                ]
            end
            format.html { redirect_to parent_post_path(@post) }
        end
    end

    def update
        @comment = @post.comments.find(params[:id])
        if user_signed_in?
            unless current_user == @comment.user || current_user.admin?
                redirect_to parent_post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        elsif customer_signed_in?
            unless current_customer == @comment.customer
                redirect_to parent_post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        end

        respond_to do |format|
            if @comment.update(comment_params)
                format.turbo_stream do
                    render turbo_stream: turbo_stream.replace(
                        view_context.dom_id(@comment),
                        partial: "comments/comment",
                        locals: { comment: @comment, post: @post }
                    )
                end
                format.html { redirect_to parent_post_path(@post), notice: "Comment has been updated!" }
            else
                format.turbo_stream do
                    render turbo_stream: turbo_stream.replace(
                        "edit-form-#{@comment.id}",
                        partial: "comments/form",
                        locals: { comment: @comment, post: @post, submit_label: "Update" }
                    )
                end
                format.html { redirect_to parent_post_path(@post), alert: "Comment WAS NOT updated!" }
            end
        end
    end

    private

    def authenticate_user_or_customer!
        unless user_signed_in? || customer_signed_in?
            redirect_to new_user_session_path, alert: "Please sign in to continue."
        end
    end

    def set_post
        if params[:post_id]
            @post = @site.posts.find_by!(permalink: params[:post_id])
        elsif params[:featured_id]
            @post = @site.posts.find_by!(permalink: params[:featured_id])
        end
    end

    def parent_post_path(post)
        post.feature? ? featured_path(post) : post_path(post)
    end

    def comment_params
        params.require(:comment).permit(:body)
    end

    def set_comment
        @comment = @site.comments.find(params[:id])
    end
end
