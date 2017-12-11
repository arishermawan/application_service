# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Customer.create!(
#   name: 'aris',
#   email: 'aris@customer.com',
#   phone: '082310232303',
#   password: 'password',
#   password_confirmation: 'password'
# )

Driver.create!(
  name: 'aris',
  email: 'aris@driver.com',
  phone: '082310232303',
  service: 1,
  password: 'password',
  password_confirmation: 'password'
)

require 'faker'
25.times do |n|
  name = Faker::Name.name
  email = "user#{n+1}@goscholar.id"
  phone = "081298776#{n+10}"
  password = "password"
  Customer.create!(
    name: name,
    email: email,
    phone: phone,
    password: password,
    password_confirmation: password
  )

end
