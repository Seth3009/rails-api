# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p "Seeding 20 books"

20.times do |n|
  Book.create! title: Faker::Book.title, author: Faker::Book.author, image: Faker::Avatar.image
end

p "Seeding 10 users"

10.times do |n|
  User.create! email: Faker::Internet.email, password: "Abcd1234"
end

p "Seeding 100 reviews"
100.times do |n|
  Review.create! title: "best book ever", content_rating: rand(1..10),
  recommend_rating: rand(1..10),
  user_id: rand(1..10), book_id: rand(1..20)
end