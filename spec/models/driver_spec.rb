require 'rails_helper'

RSpec.describe Driver, type: :model do
  it "has a valid factory" do
    expect(build(:driver)).to be_valid
  end

  it "is invalid without name" do
    driver = build(:driver, name: nil)
    driver.valid?
    expect(driver.errors[:name]).to include("can't be blank")
  end

  it "is invalid without email" do
    driver = build(:driver, email: nil)
    driver.valid?
    expect(driver.errors[:email]).to include("can't be blank")
  end

  it "is invalid with non email format" do
    driver = build(:driver, email: 'invalidemail')
    driver.valid?
    expect(driver.errors[:email]).to include("is invalid")
  end

  it "is invalid with name length greater than 50" do
    name = 'a' * 51
    driver = build(:driver, name: name)
    driver.valid?
    expect(driver.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it "is invalid with email length greater than 250" do
    email = 'a' * 245 + 'abcd@ok.com'
    driver = build(:driver, email: email)
    driver.valid?
    expect(driver.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "is invalid without phone" do
    driver = build(:driver, phone: nil)
    driver.valid?
    expect(driver.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with phone length greater than 15" do
    driver = build(:driver, phone: '0823232323232311')
    driver.valid?
    expect(driver.errors[:phone]).to include('is too long (maximum is 15 characters)')
  end

  it "is invalid with phone length less than 6" do
    driver = build(:driver, phone: '0823')
    driver.valid?
    expect(driver.errors[:phone]).to include('is too short (minimum is 6 characters)')
  end

  it "is invalid with duplicate email" do
    email1 = create(:driver, email: 'mail@rails.com')
    email2 = build(:driver, email: 'mail@rails.com')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is invalid with duplicate email (case insensitive)" do
    email1 = create(:driver, email: 'mail@rails.com')
    email2 = build(:driver, email: 'MAIL@RAILS.COM')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is valid if email saved as lower-case" do
    driver = build(:driver, email: 'Mail@RailS.CoM')
    driver.save
    expect(driver.email).to eq('mail@rails.com')
  end

  it "is invalid without password" do
    driver = build(:driver, password: nil)
    driver.valid?
    expect(driver.errors['password']).to include("can't be blank")
  end

  it "is invalid with password less than 6 characters" do
    driver = build(:driver, password: 'abc12', password_confirmation:'abc12')
    driver.valid?
    expect(driver.errors['password']).to include('is too short (minimum is 6 characters)')
  end

  it "is invalid without a service type" do
    driver = build(:driver, service: nil)
    driver.valid?
    expect(driver.errors[:service]).to include("is not included in the list")
  end

  describe "get_geocode" do
    before :each do
      @driver = build(:driver, location: 'sarinah')
      @wrong_driver = create(:driver)
      @wrong_driver.update_attributes(location: "dlfjasdlfj")

    end
    context "with valid attributes" do
      it "return coordinate of an address" do
        expect(@driver.get_geocode.empty?).not_to eq(true)
      end
    end

    context "with invalid attributes" do
      it "return empty string" do
        expect(@wrong_driver.get_geocode.empty?).to eq(true)
      end
    end
  end

  context "parsing saved driver address and coordinate" do
    before :each do
      @driver = create(:driver)
      @driver.update_attributes(location: "Kolla Sabang")
    end

    describe "address" do
      it 'return current driver address' do
        expect(@driver.address).to eq('Kolla Sabang')
      end
    end

    describe "longitude" do
      it 'return current driver longitude' do
        expect(@driver.longitude).to eq(106.824948)
      end
    end

    describe "latitude" do
      it 'return current driver address' do
        expect(@driver.latitude).to eq(-6.185512)
      end
    end
  end

































end
