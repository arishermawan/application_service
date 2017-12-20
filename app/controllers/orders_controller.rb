class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update]
  before_action :logged_in_customer
  before_action :correct_driver, only:[:edit]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def gocar
    @order = Order.new
  end

  def goride
    @order = Order.new
  end

  def check
    @order = Order.new(order_params)
    @order.customer_id = session[:user_id]
    respond_to do |format|
      if @order.valid?
        format.html{render :confirm}
      else
        if @order.service == 'gocar'
          format.html{render :gocar}
        else
          format.html{render :goride}
        end
      end
    end
  end

  def confirm
    @order = Order.new(order_params)
  end

  def create
    @order = Order.new(order_params)

    @order.customer_id = session[:user_id]
    respond_to do |format|
      if @order.save
        @order.send_to_transaction_services
        format.html{ redirect_to @order}
      else
        format.html{render :new}
      end
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    if @order.update_attributes(status_params)
      @order.driver.update_attributes(location_id: nil)
      @order.update_to_transaction_services
      flash[:success] = "Job Status Updated!!"
      redirect_to @order
    else
      render 'edit'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:pickup, :destination, :payment, :distance, :service, :total, :status)
  end

  def status_params
    params.require(:order).permit(:status)
  end

  def logged_in_customer
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_driver
    @order = Order.find(params[:id])
    redirect_to(root_url) unless @order.driver == @current_user
  end

end
