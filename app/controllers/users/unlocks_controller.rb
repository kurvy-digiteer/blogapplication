# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  before_action :set_site, only: [ :show, :create ]

  # GET /resource/unlock/new
  # def new
  #   super
  # end

  # POST /resource/unlock
  # def create
  #   super
  # end

  # GET /resource/unlock?unlock_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  private

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end

  # Override the default after_unlock_path_for to include site context
  def after_unlock_path_for(resource)
    site_admin_path(@site)
  end
end
