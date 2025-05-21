# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  before_action :set_site, only: [ :show, :create ]

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end

  # Override the default after_confirmation_path_for to include site context
  def after_confirmation_path_for(resource_name, resource)
    site_admin_path(@site)
  end
end
