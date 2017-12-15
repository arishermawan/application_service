require 'rails_helper'

RSpec.describe GopayCredit, type: :model do

  it "has a valid factory" do
    expect(build(:gopay_credit)).to be_valid
  end

  it "is valid with credit, user_id and type" do
    expect(build(:gopay_credit)).to be_valid
  end

  it "is invalid without credit" do
    gopay = build(:gopay_credit, credit:nil)
    gopay.valid?
    expect(gopay.errors['credit']).to include('is not a number')
  end

  it "is invalid without user_id" do
    gopay = build(:gopay_credit, user_id:nil)
    gopay.valid?
    expect(gopay.errors['user_id']).to include("can't be blank")
  end

  it "is invalid without user_type" do
    gopay = build(:gopay_credit, user_type:nil)
    gopay.valid?
    expect(gopay.errors['user_type']).to include("can't be blank")
  end

  it "is invalid with duplicate user_id & user_type" do
  end
end
