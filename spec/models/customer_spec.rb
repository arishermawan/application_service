require 'rails_helper'

RSpec.describe Customer, type: :model do

  it "has a valid factory" do
    expect(build(:customer)).to be_valid
  end

  it "is invalid without name" do
    customer = build(:customer, name: nil)
    customer.valid?
    expect(customer.errors[:name]).to include("can't be blank")
  end

  it "is invalid without email" do
    customer = build(:customer, email: nil)
    customer.valid?
    expect(customer.errors[:email]).to include("can't be blank")
  end

  it "is invalid with non email format" do
    customer = build(:customer, email: 'invalidemail')
    customer.valid?
    expect(customer.errors[:email]).to include("is invalid")
  end

  it "is invalid with name length greater than 50" do
    name = 'a' * 51
    customer = build(:customer, name: name)
    customer.valid?
    expect(customer.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it "is invalid with email length greater than 250" do
    email = 'a' * 245 + 'abcd@ok.com'
    customer = build(:customer, email: email)
    customer.valid?
    expect(customer.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "is invalid without phone" do
    customer = build(:customer, phone: nil)
    customer.valid?
    expect(customer.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with phone length greater than 15" do
    customer = build(:customer, phone: '0823232323232311')
    customer.valid?
    expect(customer.errors[:phone]).to include('is too long (maximum is 15 characters)')
  end

  it "is invalid with phone length less than 6" do
    customer = build(:customer, phone: '0823')
    customer.valid?
    expect(customer.errors[:phone]).to include('is too short (minimum is 6 characters)')
  end

  it "is invalid with duplicate email" do
    email1 = create(:customer, email: 'mail@rails.com')
    email2 = build(:customer, email: 'mail@rails.com')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is invalid with duplicate email (case insensitive)" do
    email1 = create(:customer, email: 'mail@rails.com')
    email2 = build(:customer, email: 'MAIL@RAILS.COM')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is valid if email saved as lower-case" do
    customer = build(:customer, email: 'Mail@RailS.CoM')
    customer.save
    expect(customer.email).to eq('mail@rails.com')
  end

  it "is invalid without password" do
    customer = build(:customer, password: nil)
    customer.valid?
    expect(customer.errors['password']).to include("can't be blank")
  end

  it "is invalid with password less than 6 characters" do
    customer = build(:customer, password: 'abc12', password_confirmation:'abc12')
    customer.valid?
    expect(customer.errors['password']).to include('is too short (minimum is 6 characters)')
  end

  it "is invalid without gopay" do
    customer = create(:customer)
    gopay = nil
    customer.update(gopay: gopay)
    expect(customer.errors[:gopay]).to include("can't be blank")
  end

  it "is invalid if gopay non numeric" do
    customer = create(:customer)
    gopay = '200 rupiah'
    customer.update(gopay: gopay)
    expect(customer.errors[:gopay]).to include('is not a number')
  end

  it "is invalid if gopay less than 0.01" do
    customer = create(:customer)
    gopay = 0
    customer.update(gopay: gopay)
    expect(customer.errors[:gopay]).to include('must be greater than or equal to 0.01')
  end


end
