class CommentsController < ApplicationController
    before_action :authenticate_user_or_customer!
    before_action :set_post

    def create
        @comment = @post.comments.create(comment_params)
        if user_signed_in?
            @comment.user = current_user
        else
            @comment.customer = current_customer
        end

        if @comment.save
            flash[:notice] = "Your comment has been created"
            redirect_to post_path(@post)
        else
            flash[:alert] = "YOUR COMMENT WAS NOT CREATED"
            redirect_to post_path(@post)
        end
    end

    def destroy
        @comment = @post.comments.find(params[:id])
        if user_signed_in?
            unless current_user == @comment.user || current_user.admin?
                redirect_to post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        elsif customer_signed_in?
            unless current_customer == @comment.customer
                redirect_to post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        end

        @comment.destroy
        redirect_to post_path(@post)
    end

    def update
        @comment = @post.comments.find(params[:id])
        if user_signed_in?
            unless current_user == @comment.user || current_user.admin?
                redirect_to post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        elsif customer_signed_in?
            unless current_customer == @comment.customer
                redirect_to post_path(@post), alert: "You are not authorized to perform this action."
                return
            end
        end

        respond_to do |format|
            if @comment.update(comment_params)
                format.html { redirect_to post_url(@post), notice: "Comment has been updated!" }
            else
                format.html { redirect_to post_url(@post), alert: "Comment WAS NOT updated!" }
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
        @post = Post.find(params[:post_id])
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end
