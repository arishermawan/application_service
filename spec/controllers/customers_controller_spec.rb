require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  before :each do
    customer = create(:customer)
    session[:user_id] = customer.id
    session[:user_type] = 'Customer'
  end

  describe 'GET #index' do
    # it 'populates an array of customers' do
    #   customer1 = create(:customer)
    #   customer2 = create(:customer)
    #   get :index, params:{ page: 1 }
    #   expect(assigns(:customers)).to match_array([customer1, customer2])
    # end

    it 'render the :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested customer to @customers' do
      customer = create(:customer)
      get :show, params:{id: customer}
      expect(assigns(:customer)).to eq customer
    end

    it 'render the show template' do
      customer = create(:customer)
      get :show, params:{id: customer}
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before :each do
      session[:user_id] = nil
      session[:user_type] = nil
    end
    it 'assigns a new customer to @customer' do
      get :new
      expect(assigns(:customer)).to be_a_new(Customer)
    end

    it "render the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it "save the new customer in the database" do
        expect{
          post :create, params: { customer: attributes_for(:customer) }
        }.to change(Customer, :count).by(1)
      end

      it "redirects to customer#show" do
        post :create, params: { customer: attributes_for(:customer) }
        expect(response).to redirect_to(customer_path(assigns[:customer]))
      end
    end

    context "with invalid attributes" do
      it "does not save the new customer in the database" do
        expect{
          post :create, params: { customer: attributes_for(:invalid_customer) }
        }.not_to change(Customer, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { customer: attributes_for(:invalid_customer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      @customer = create(:customer)
      session[:user_id] = @customer.id
      session[:user_type] = 'Customer'
    end
    it "assigns a new Customer to @customer" do
      get :edit, params: {id: @customer}
      expect(assigns(:customer)).to eq @customer
    end

    it "render the :edit template" do
      get :edit, params:{id: @customer}
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before :each do
      @customer = create(:customer)
      session[:user_id] = @customer.id
      session[:user_type] = 'Customer'
    end

    context 'with valid attributes' do
      it "locates the requested @customer" do
        patch :update, params: { id: @customer, customer: attributes_for(:customer) }
        expect(assigns(:customer)).to eq @customer
      end

      it "changes @customer's attributes" do
        patch :update, params: {id: @customer, customer: attributes_for(:customer, name: 'Nautilus') }
        @customer.reload
        expect(@customer.name).to eq('Nautilus')
      end

      it "redirects to the customer" do
        patch :update, params: { id: @customer, customer: attributes_for(:customer) }
        expect(response).to redirect_to @customer
      end
    end

    context 'with invalid attributes' do
      it "does not update the customer in the database" do
        patch :update, params: { id: @customer, customer: attributes_for(:customer, name: 'Nautilus', email: nil) }
        @customer.reload
        expect(@customer.name).not_to eq('Nautilus')
      end
      it "re-render the :edit template" do
        patch :update, params: {id:@customer, customer: attributes_for(:invalid_customer) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #topup' do
    before :each do
      @customer = create(:customer)
      session[:user_id] = @customer.id
      session[:user_type] = 'Customer'
    end
    it "assigns a new Customer to @customer" do
      get :edit, params: {id: @customer}
      expect(assigns(:customer)).to eq @customer
    end

    it "render the :edit template" do
      get :topup, params:{id: @customer}
      expect(response).to render_template :topup
    end
  end

  describe 'PATCH #commit_topup' do
    before :each do
      @customer = create(:customer, gopay: 50000)
      session[:user_id] = @customer.id
      session[:user_type] = 'Customer'
    end

    context 'with valid gopay amount' do
      it "locates the requested @customer" do
        patch :commit_topup, params: { id: @customer, customer: { gopay: 50000 } }
        expect(assigns(:customer)).to eq @customer
      end

      it "changes @customer's gopay balance" do
        patch :commit_topup, params: {id: @customer, customer: { gopay:50000 } }
        @customer.reload
        expect(@customer.gopay).to eq(100000)
      end

      it "redirects to the customer" do
        patch :commit_topup, params: { id: @customer, customer: { gopay:50000 } }
        expect(response).to redirect_to @customer
      end
    end

    context 'with invalid gopay amount' do
      it "does not update the customer's gopay balance in the database" do
        patch :commit_topup, params: { id: @customer, customer: { gopay:'Rp 5000' } }
        @customer.reload
        expect(@customer.gopay).not_to eq('Rp 5000')
      end
      it "re-render the :topup template" do
        patch :commit_topup, params: {id:@customer, customer: { gopay:'Rp 5000' } }
        expect(response).to render_template :topup
      end
    end
  end

  # describe 'DELETE #destroy' do
  #   before :each do
  #     @custmer = create(:customer)
  #   end

  #   it "delete the customer from the database" do
  #     expect{
  #       delete :destroy, params: { id: @customer }
  #     }.to change(Customer, :count).by(-1)

  #   end

  #   it "redirects to the customer#index" do
  #     delete :destroy, params: { id: @customer }
  #     expect(response).to redirect_to customers_url
  #   end
  # end

end
