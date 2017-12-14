require 'rails_helper'

RSpec.describe Location, type: :model do
  it "has valid location" do
    expect(build(:location)).to be_valid
  end

  it "has valid with address and coordinate" do
    expect(build(:location)).to be_valid
  end

  it "invalid without an address" do
    location = build(:location, address: nil)
    expect(location.errors['addres']).to include?("can't be blank")
  end

  it "invalid without an address" do
    location = build(:location, address: nil)
    expect(location.errors['addres']).to include?("can't be blank")
  end


end
