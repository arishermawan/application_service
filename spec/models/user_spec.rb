require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without name" do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with non email format" do
    user = build(:user, email: 'invalidemail')
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end

  it "is invalid with name length greater than 50" do
    name = 'a' * 51
    user = build(:user, name: name)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it "is invalid with email length greater than 250" do
    email = 'a' * 245 + 'abcd@ok.com'
    user = build(:user, email: email)
    user.valid?
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "is invalid without phone" do
    user = build(:user, phone: nil)
    user.valid?
    expect(user.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with phone length greater than 15" do
    user = build(:user, phone: '0823232323232311')
    user.valid?
    expect(user.errors[:phone]).to include('is too long (maximum is 15 characters)')
  end

  it "is invalid with phone length less than 6" do
    user = build(:user, phone: '0823')
    user.valid?
    expect(user.errors[:phone]).to include('is too short (minimum is 6 characters)')
  end

  it "is invalid with duplicate email" do
    email1 = create(:user, email: 'mail@rails.com')
    email2 = build(:user, email: 'mail@rails.com')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is invalid with duplicate email (case insensitive)" do
    email1 = create(:user, email: 'mail@rails.com')
    email2 = build(:user, email: 'MAIL@RAILS.COM')
    email2.valid?
    expect(email2.errors[:email]).to include('has already been taken')
  end

  it "is valid if email saved as lower-case" do
    user = build(:user, email: 'Mail@RailS.CoM')
    user.save
    expect(user.email).to eq('mail@rails.com')
  end

  it "is invalid without password" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors['password']).to include("can't be blank")
  end

  it "is invalid with password less than 6 characters" do
    user = build(:user, password: 'abc12', password_confirmation:'abc12')
    user.valid?
    expect(user.errors['password']).to include('is too short (minimum is 6 characters)')
  end


end
