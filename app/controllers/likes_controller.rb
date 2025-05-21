class LikesController < ApplicationController
  before_action :authenticate_user_or_customer!
  before_action :set_post

  def create
    @like = @post.likes.build
    @like.site = @site
    @like.liker = current_user if user_signed_in?
    @like.liker = current_customer if customer_signed_in?

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
    @post = @site.posts.find_by!(permalink: params[:post_id])
  end
end
