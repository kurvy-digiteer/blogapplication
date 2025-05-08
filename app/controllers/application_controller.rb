class ApplicationController < ActionController::Base
  before_action :set_query

  def set_query
    @query = Post.ransack(params[:q])
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
