# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    name "aris h"
    email "aris@gmail.com"
    gopay "9.99"
    phone "0823102323023"
    password "abc123"
    password_confirmation "abc123"
  end

  factory :invalid_customer, parent: :user do
    name nil
    email nil
    gopay nil
    phone nil
    password nil
    password_confirmation nil
  end
end
