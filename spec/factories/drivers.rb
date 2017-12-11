
FactoryGirl.define do
  factory :driver do
    name "aris h"
    email "aris@gmail.com"
    gopay "9.99"
    phone "0823102323023"
    location "MyString"
    service "goride"
    password "abc123"
    password_confirmation "abc123"
  end

  factory :invalid_driver, parent: :user do
    name nil
    email nil
    gopay nil
    phone nil
    service nil
    password nil
    password_confirmation nil
  end
end
