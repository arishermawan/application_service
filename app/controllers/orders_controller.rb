class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html{render :show, notice: "orders succesfully saved"}
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
