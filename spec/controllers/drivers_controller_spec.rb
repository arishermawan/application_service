require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  before :each do
    driver = create(:driver)
    session[:user_id] = driver.id
    session[:user_type] = 'Driver'
  end

  describe 'GET #index' do
    # it 'populates an array of drivers' do
    #   driver1 = create(:driver)
    #   driver2 = create(:driver)
    #   get :index
    #   expect(assigns(:drivers)).to match_array([driver1, driver2])
    # end

    it 'render the :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested driver to @drivers' do
      driver = create(:driver)
      get :show, params:{id: driver}
      expect(assigns(:driver)).to eq driver
    end

    it 'render the show template' do
      driver = create(:driver)
      get :show, params:{id: driver}
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before :each do
      session[:user_id] = nil
      session[:user_type] = nil
    end
    it 'assigns a new driver to @driver' do
      get :new
      expect(assigns(:driver)).to be_a_new(Driver)
    end

    it "render the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before :each do
      @driver = create(:driver)
      session[:user_id] = @driver.id
      session[:user_type] = 'Driver'
    end
    it "assigns a new Driver to @driver" do
      get :edit, params: {id: @driver}
      expect(assigns(:driver)).to eq @driver
    end

    it "render the :edit template" do
      get :edit, params:{id: @driver}
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it "save the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.to change(Driver, :count).by(1)
      end

      it "redirects to driver#show" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(response).to redirect_to(driver_path(assigns[:driver]))
      end
    end

    context "with invalid attributes" do
      it "does not save the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:invalid_driver) }
        }.not_to change(Driver, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @driver = create(:driver)
      session[:user_id] = @driver.id
      session[:user_type] = 'Driver'
    end

    context 'with valid attributes' do
      it "locates the requested @driver" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(assigns(:driver)).to eq @driver
      end

      it "changes @driver's attributes" do
        patch :update, params: {id: @driver, driver: attributes_for(:driver, name: 'Nautilus') }
        @driver.reload
        expect(@driver.name).to eq('Nautilus')
      end

      it "redirects to the driver" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(response).to redirect_to @driver
      end
    end

    context 'with invalid attributes' do
      it "does not update the driver in the database" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, name: 'Nautilus', email: nil) }
        @driver.reload
        expect(@driver.name).not_to eq('Nautilus')
      end
      it "re-render the :edit template" do
        patch :update, params: {id:@driver, driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #set_location' do
    before :each do
      @driver = create(:driver)
      session[:user_id] = @driver.id
      session[:user_type] = 'Driver'
    end
    it "assigns a new Customer to @driver" do
      get :edit, params: {id: @driver}
      expect(assigns(:driver)).to eq @driver
    end

    it "render the :edit template" do
      get :set_location, params:{id: @driver}
      expect(response).to render_template :set_location
    end
  end

  describe 'PATCH #commit_location' do
    before :each do
      @driver = create(:driver, gopay: 50000)
      session[:user_id] = @driver.id
      session[:user_type] = 'Driver'
    end

    context 'with valid location' do
      it "locates the requested @driver" do
        patch :commit_location, params: { id: @driver, driver: { location: 'sarinah' } }
        expect(assigns(:driver)).to eq @driver
      end

      it "changes driver's location" do
        patch :commit_location, params: {id: @driver, driver: { location: 'sarinah' } }
        @driver.reload
        expect(@driver.gopay).not_to eq(nil)
      end

      it "redirects to the driver" do
        patch :commit_location, params: { id: @driver, driver: { location: 'sarinah' } }
        expect(response).to redirect_to @driver
      end
    end

    context 'with invalid location' do
      it "does not update the driver's gopay balance in the database" do
        patch :commit_location, params: { id: @driver, driver: { location: 'jljdslkfjds' } }
        @driver.reload
        expect(@driver.gopay).not_to eq('Rp 5000')
      end
      it "re-render the :set_location template" do
        patch :commit_location, params: {id:@driver, driver: { location: 'jljdslkfjds' } }
        expect(response).to render_template :set_location
      end
    end
  end

  # describe 'DELETE #destroy' do
  #   before :each do
  #     @driver = create(:driver)
  #   end

  #   it "delete the driver from the database" do
  #     expect{
  #       delete :destroy, params: { id: @driver }
  #     }.to change(Driver, :count).by(-1)

  #   end

  #   it "redirects to the driver#index" do
  #     delete :destroy, params: { id: @driver }
  #     expect(response).to redirect_to drivers_url
  #   end
  # end
end
