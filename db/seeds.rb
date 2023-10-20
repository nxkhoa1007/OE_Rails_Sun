# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  dob: Faker::Date.birthday(min_age: 18, max_age: 65),
  gender: Faker::Base.rand(0..2)
)

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  gender = Faker::Base.rand(0..2)

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    dob: dob,
    gender: gender
  )

end
