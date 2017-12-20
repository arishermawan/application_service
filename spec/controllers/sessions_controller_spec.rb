require 'rails_helper'

describe SessionsController do

  describe "GET#{}new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST#create" do
    before :each do
      @customer = create(:customer, email:'aris@gmail.com', password: 'oldpassword', password_confirmation: 'oldpassword')
    end

    context "with valid email and password" do
      it "assigns customer to session variable" do
        post :create, params:{ session: { email: 'aris@gmail.com', password: 'oldpassword'} }
        expect(session[:user_id]).to eq(@customer.id)
      end

      it "redirect to customer page" do
        post :create, params:{ email: 'aris@gmail.com', password: 'oldpassword' }
        expect(response).to redirect_to @customer
      end
    end

    context "with invalid email and password" do
      it "redirect to login page" do
        post :create, params:{ email: 'aris@gmail.com', password: 'wrongpassword' }
        expect(response).to redirect_to login_url
      end
    end

  end

  describe "DELETE#destroy" do
    before :each do
      @customer = create(:customer)
    end

    it "remove user_id from session " do
      delete :destroy, params: {id:@customer}
      expect(session[:user_id]).to eq(nil)
    end

    it "redirect to login page" do
      delete :destroy, params: {id: @customer}
      expect(response).to redirect_to login_url
    end
  end
end
