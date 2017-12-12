class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def check
    @order = Order.new(order_params)

    @order.customer_id = session[:user_id]
    respond_to do |format|
      if @order.valid?
        format.html{render :confirm}
      else
        format.html{render :new}
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
      if @order.save?
        format.html{render :show}
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
    params.require(:order).permit(:pickup, :destination, :payment, :distance, :total)
  end
end