# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  before_action :set_site, only: [ :new, :create ]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end

  # Override the default after_sign_in_path_for to include site context
  def after_sign_in_path_for(resource)
    site_path(@site)
  end

  # Override the default after_sign_out_path_for to include site context
  def after_sign_out_path_for(resource_or_scope)
    site_path(@site)
  end
end
