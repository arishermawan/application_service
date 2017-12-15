# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gopay_credit do
    credit 50000.0
    user_id 1
    user_type 0
  end
end
