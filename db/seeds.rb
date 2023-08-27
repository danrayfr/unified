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

admin = User.create!(email: 'admin@unified.com', password: 'password', password_confirmation: 'password', role: 'admin')
qa = User.create!(email: 'qa@unified.com', password: 'password', password_confirmation: 'password', role: 'qa')

projectq = Account.create!(name: 'Project Q', description: 'Technical Account')
everpresent = Account.create!(name: 'Everpresent', description: 'Support Account ')

projectq.users << admin
projectq.users << qa
everpresent.users << admin
