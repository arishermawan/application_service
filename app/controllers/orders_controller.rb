class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

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

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:pickup, :destination, :payment, :distance, :service, :total)
  end
end
