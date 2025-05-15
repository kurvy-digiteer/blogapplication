class Admin::CustomersController < Admin::AdminController
  before_action :set_customer, only: [:edit, :update, :destroy]

  def index
    @customers = Customer.includes(:posts, :comments).order(created_at: :desc)
  end

  def edit
  end

  def update
    customer_params = customer_params()
    if customer_params[:password].blank? 
      customer_params.delete(:password)
      customer_params.delete(:password_confirmation)
    end

    if @customer.update(customer_params)
      redirect_to admin_customers_path, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to admin_customers_path, notice: "Customer was successfully deleted."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :password, :password_confirmation)
  end
end
