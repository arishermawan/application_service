# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Customer.create!(
#   name: 'aris',
#   email: 'aris@gmail.com',
#   phone: '082310232303',
#   password: 'password',
#   password_confirmation: 'password'
# )

Driver.create!(
  name: 'aris',
  email: 'aris@gmail.com',
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


require 'faker'
20.times do |n|
  name = Faker::Name.name
  email = "driver#{n+1}@goscholar.id"
  phone = "081898809#{n+10}"
  password = "password"
  service = 0
  n.odd? ? service = 0 : service = 1
  Driver.create!(
    name: name,
    email: email,
    phone: phone,
    service: service,
    password: password,
    password_confirmation: password
  )

end

locations = [
  'Kolla Sabang',
  'Kolla Sabang',
  'Sarinah',
  'Glodok',
  'Blok M',
  'Kemang',
  'Kebayoran',
  'Kemayoran',
  'Mangga Dua',
  'Pondok Pinang',
  'Pondok Indah',
  'Dukuh Atas',
  'Panglima Polim',
  'Lebak Bulus',
  'Bundaran Hotel Indonesia',
  'Harmoni Jakarta',
  'Senayan',
  'Ciledung Jakarta',
  'Cipulir Jakarta',
  'Bintaro',
  'Kemang',
  'Kemanggisan'
]

21.times do |n|
  driver = Driver.find(n+1)
  driver.update_attributes!(location: locations[n+1])
end
