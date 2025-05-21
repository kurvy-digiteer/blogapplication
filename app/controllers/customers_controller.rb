class CustomersController < ApplicationController
  before_action :set_customer

  def profile
    @customer.update(views: @customer.views + 1)
  end

  private
  def set_customer
    @customer = Customer.find_by!(name: params[:name])
  end
end
