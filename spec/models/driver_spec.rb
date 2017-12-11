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

end
