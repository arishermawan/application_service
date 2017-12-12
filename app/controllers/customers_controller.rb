class CustomersController < ApplicationController
  before_action :logged_in_customer, only: [:edit, :update]
  before_action :correct_customer,   only: [:edit, :update]

  def index
    @customers = Customer.paginate(page:params[:page])
    @customers.per_page = 10
  end

  def new
    if logged_in?
      redirect_to current_customer
    end
  @customer = Customer.new
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      log_in @customer
      flash[:success] = "Welcome to the Go-jek Web Services App"
      redirect_to @customer
    else
      render 'new'
    end
  end

  def topup
    @customer = Customer.find(params[:id])
  end

  def commit_topup
    @customer = Customer.find(params[:id])

    if params[:customer][:gopay].to_i != 0 && !params[:customer][:gopay].match(/[^0-9]/)
      params[:customer][:gopay] = params[:customer][:gopay].to_i + @customer.gopay
    end

    if @customer.update_attributes(gopay_params)
      flash[:success] = "Topup Success"
      redirect_to @customer
    else
      render 'topup'
    end
  end

  private

    def customer_params
      params.require(:customer).permit(:name, :email, :phone, :password, :password_confirmation)
    end

    def gopay_params
      params.require(:customer).permit(:gopay)
    end

    def logged_in_customer
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_customer
      @customer = Customer.find(params[:id])
      redirect_to(root_url) unless @customer == current_user
    end
end
