# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "Deleting the Data"
Listing.delete_all
User.delete_all

puts "Creating user"
user = FactoryBot.create(:user, email: "test@example.com", password:"test")

puts "Creating lots of users"
100.times do |n|
    FactoryBot.create(:user)
end

puts "Creating Listings"
User.all.each do |u|
    5.times do
        FactoryBot.create(:listing, user: u)
    end
end