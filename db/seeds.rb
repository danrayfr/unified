# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
Account.destroy_all

danray = User.create!(email: 'danray@joinable.com', password: 'password', password_confirmation: 'password')
genie = User.create!(email: 'genie@joinable.com', password: 'password', password_confirmation: 'password')

account1 = Account.create!(name: 'Account 1', description: 'dadsadsa')
account2 = Account.create!(name: 'Account 2', description: 'djkahfjkdsahfkjsda')

account1.users << danray
account1.users << genie
account2.users << danray
