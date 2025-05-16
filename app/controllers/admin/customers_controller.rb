class Admin::CustomersController < Admin::AdminController
  helper Admin::SortableHelper
  before_action :set_customer, only: [:edit, :update, :destroy]

  def index
    sortable_columns = %w[id name email posts_count comments_count created_at]
    sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : 'id'
    sort_direction = params[:direction] == 'asc' ? 'asc' : 'desc'
    @customers = Customer.left_joins(:posts, :comments)
                       .select('customers.*, COUNT(DISTINCT posts.id) as posts_count, COUNT(DISTINCT comments.id) as comments_count')
                       .group('customers.id')
                       .order("#{sort_column} #{sort_direction}")
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
