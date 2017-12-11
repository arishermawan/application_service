
FactoryGirl.define do
  factory :driver do
    name "aris h"
    email "aris@gmail.com"
    gopay "9.99"
    phone "0823102323023"
    location "MyString"
    type 1
    password "abc123"
    password_confirmation "abc123"
  end

  factory :invalid_driver, parent: :user do
    name nil
    email nil
    gopay nil
    phone nil
    type nil
    password nil
    password_confirmation nil
  end
end
