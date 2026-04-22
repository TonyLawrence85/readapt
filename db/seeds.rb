# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning the database"
User.destroy_all

puts "Creating users"
user = User.create!(
  email: "test@test.com",
  password: "password"
)

puts "Creating texts"
Text.create!(
  title: "Mon premier texte",
  content: "Ceci est le contenu du texte",
  favourite: "false",
  user: user
)

puts "Seeding completed"

user = User.first

Setting.create!(
  font: "Arial",
  syllable_color: "red",
  letter_spacing: "2px",
  user: user
)
