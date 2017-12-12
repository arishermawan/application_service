# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    pickup "kolla sabang"
    destination "sarinah mall"
    payment 'gopay'
    distance "9.99"
    total "9000"

    association :customer
    association :driver
  end
end
