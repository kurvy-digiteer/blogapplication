class LikesController < ApplicationController
  before_action :authenticate_user_or_customer!
  before_action :set_post

  def create
    @like = @post.likes.build(liker: current_liker)

    if @like.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post liked successfully." }
        format.json { render json: { likes_count: @post.likes_count, liked: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "You have already liked this post." }
        format.json { render json: { error: "You have already liked this post." }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(liker: current_liker)

    if @like&.destroy
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post unliked successfully." }
        format.json { render json: { likes_count: @post.likes_count, liked: false } }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "Unable to unlike the post." }
        format.json { render json: { error: "Unable to unlike the post." }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id]) || Post.find_by(permalink: params[:post_id])
    unless @post
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Post not found." }
        format.json { render json: { error: "Post not found." }, status: :not_found }
      end
    end
  end
end
