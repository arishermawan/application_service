require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  before :each do
    customer = create(:customer)
    session[:user_id] = customer.id
    session[:user_type] = 'Customer'
  end

  describe 'GET #index' do

    it "populates an array of all orders" do
      customer = create(:customer)
      order1  = create(:order, customer: customer)
      order2  = create(:order, customer: customer)
      get :index
      expect(assigns(:orders)).to match_array([order1, order2])
    end

    it "renders te :index tmplate" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "assigns the requested order to @order" do
      order = create(:order)
      get :show, params:{ id: order }
      expect(assigns(:order)).to eq order
    end

    it "renders the :show tmplate" do
      order = create(:order)
      get :show, params:{ id: order }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "assigns a new order to @order" do
      get :new
      expect(assigns(:order)).to be_a_new(Order)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #goride' do
    it "assigns a new order to @order" do
      get :goride
      expect(assigns(:order)).to be_a_new(Order)
    end

    it "renders the goride template" do
      get :goride
      expect(response).to render_template :goride
    end
  end

  describe 'GET #gocar' do
    it "assigns a new order to @order" do
      get :gocar
      expect(assigns(:order)).to be_a_new(Order)
    end

    it "renders the gocar template" do
      get :gocar
      expect(response).to render_template :gocar
    end
  end

  describe 'POST #check' do
    context "with valid attributes" do
      it "renders the :confirm template" do
        post :check, params:{ order: {pickup: "sarinah", destination: "kolla sabang", payment: "cash", service: "goride"} }
        expect(response).to render_template :confirm
      end
    end

    context "with invalid attributes" do
      it "does not save the new order in the database " do
        expect{
          post :check, params:{ order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it "re-renders the :goride template if service is goride" do
        post :check, params:{ order: {destination:'', pickup:'', service:'goride'} }
        expect(response).to render_template :goride
      end

      it "re-renders the :gocar template if service is gocar" do
        post :check, params:{ order: {destination:'', pickup:'', service:'gocar'} }
        expect(response).to render_template :gocar
      end
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "save the new order in the database" do
        expect{
        post :create, params:{ order: attributes_for(:order) }
        }.to change(Order, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not save the new order in the database " do
        expect{
          post :create, params:{ order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it "re-renders the :new template" do
        post :create, params:{ order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
  end


end
