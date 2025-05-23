class LikesController < ApplicationController
  before_action :authenticate_user_or_customer!
  before_action :set_post

  def create
    @like = @post.likes.build(liker: current_liker)

    if @like.save
      flash[:notice] = "Post liked successfully."
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { likes_count: @post.likes_count, liked: true, notice: flash[:notice] } }
      end
    else
      flash[:alert] = "You have already liked this post."
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { error: flash[:alert] }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(liker: current_liker)

    if @like&.destroy
      flash[:notice] = "Post unliked successfully."
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { likes_count: @post.likes_count, liked: false, notice: flash[:notice] } }
      end
    else
      flash[:alert] = "Unable to unlike the post."
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { error: flash[:alert] }, status: :unprocessable_entity }
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
