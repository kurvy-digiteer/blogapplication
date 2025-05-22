class CustomersController < ApplicationController
  before_action :set_customer
  rescue_from ActiveRecord::RecordNotFound, with: :customer_not_found

  def profile
    @customer.update(views: @customer.views + 1)
  end

  private
  def set_customer
    @customer = Customer.find_by!(name: params[:name])
  end

  def customer_not_found
    flash[:alert] = "Customer not found"
    redirect_to root_path
  end
end
