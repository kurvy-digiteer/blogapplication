# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :set_site, only: [ :new, :create, :edit, :update ]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end

  # Override the default after_resetting_password_path_for to include site context
  def after_resetting_password_path_for(resource)
    site_admin_path(@site)
  end

  # Override the default after_sending_reset_password_instructions_path_for to include site context
  def after_sending_reset_password_instructions_path_for(resource_name)
    site_admin_path(@site)
  end
end
