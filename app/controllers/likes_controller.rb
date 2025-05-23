class LikesController < ApplicationController
  before_action :authenticate_user_or_customer!
  before_action :set_post

  def create
    @like = @post.likes.build(liker: current_liker)
    respond_to do |format|
      if @like&.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              view_context.dom_id(@post),
              partial: @post.feature ? "featured/show" : "posts/show",
              locals: {
                post: @post,
                comments: @post.comments.order(created_at: :desc)
              }),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { notice: "Post was liked successfully." }),
            turbo_stream.append("notice", html: "<script>setTimeout(() => { document.getElementById('notice').remove(); }, 3000);</script>")
          ]
        end
        format.json { render json: { likes_count: @post.likes_count, liked: true, notice: "Post was liked successfully." } }
      else
        format.html { redirect_to @post }
        format.json { render json: { error: "You have already liked this post." }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(liker: current_liker)

    respond_to do |format|
      if @like&.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              view_context.dom_id(@post),
              partial: @post.feature ? "featured/show" : "posts/show",
              locals: {
                post: @post,
                comments: @post.comments.order(created_at: :desc)
              }),
            turbo_stream.update("notice", partial: "layouts/alerts", locals: { alert: "Post was unliked." }),
            turbo_stream.append("notice", html: "<script>setTimeout(() => { document.getElementById('notice').remove(); }, 3000);</script>")
          ]
        end
        format.json { render json: { likes_count: @post.likes_count, liked: false, notice: "Post unliked successfully." } }
      else
        format.html { redirect_to @post }
        format.json { render json: { error: "Unable to unlike the post." }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id]) || Post.find_by(permalink: params[:post_id])
    unless @post
      flash[:alert] = "Post not found."
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: { error: flash[:alert] }, status: :not_found }
      end
    end
  end
end
