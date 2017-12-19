class DriversController < ApplicationController
  before_action :logged_in_driver, only: [:edit, :update]
  before_action :correct_driver,   only: [:edit, :update]

  def index
    @drivers = Driver.paginate(page:params[:page])
    @drivers.per_page = 10
  end

  def new
    if logged_in?
      redirect_to current_driver
    end
    @driver = Driver.new
  end

  def show
    @driver = Driver.find(params[:id])
  end

  def edit
    @driver = Driver.find(params[:id])
  end

  def update
    @driver = Driver.find(params[:id])
    if @driver.update_attributes(driver_params)
      flash[:success] = "Profile updated"
      redirect_to @driver
    else
      render 'edit'
    end
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      log_in @driver
      flash[:success] = "Welcome to the Go-jek Web Services App"
      redirect_to @driver
    else
      render 'new'
    end
  end

  def orders
    @driver = Driver.find(params[:id])
    @orders = @driver.orders
  end

  def set_location
    @driver = Driver.find(params[:id])
  end

  def commit_location
    @driver = Driver.find(params[:id])

    if @driver.update(location_params)
      flash[:success] = "Location Update"
      redirect_to @driver
    else
      render 'set_location'
    end
  end

  private

    def driver_params
      params.require(:driver).permit(:name, :email, :phone, :service, :password, :password_confirmation)
    end

    def location_params
      params.require(:driver).permit(:location)
    end

    def logged_in_driver
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_driver
      @driver = Driver.find(params[:id])
      redirect_to(root_url) unless @driver == current_user
    end

end
