class ApplicationController < ActionController::Base
  require "pagy/extras/calendar"  # Must be required before including
  require "pagy/extras/bootstrap" # For Bootstrap navs

  include Pagy::Backend
  before_action :set_site
  before_action :set_query
  helper_method :current_liker

  def set_query
    @query = Post.ransack(params[:q])
  end

  private

  def authenticate_user_or_customer!
    unless user_signed_in? || customer_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to like posts."
    end
  end

  def current_liker
    current_user || current_customer
  end

  # this is supposed to be for images but I have to remove the body content limit so no
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end
end
