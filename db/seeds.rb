# frozen_string_literal: true

# frozen_string_literal: true

User.destroy_all
Account.destroy_all

# Create admin and qa users
admin = User.create!(name: "Admin User", email: 'ninjafied@supportninja.com', password: 'password', password_confirmation: 'password',
                     role: 'admin', confirmed_at: Time.now)
qa = User.create!(name: "QA User", email: 'qa@supportninja.com', password: 'password', password_confirmation: 'password', role: 'qa', confirmed_at: Time.now)
manager = User.create!(name: 'Manager User', email: 'manager@supportninja.com', password: 'password', password_confirmation: 'password', role: 'qa', confirmed_at: Time.now)

danray = User.create!(employee_id: "2100949", name: 'Dan Ray Falcis Rollan', email: 'danrayrollan98@gmail.com', password: 'password', password_confirmation: 'password', role: 'agent', confirmed_at: Time.now)

# Create accounts
projectq = Account.create!(name: 'Project Q', description: 'Technical Account')
everpresent = Account.create!(name: 'Everpresent', description: 'Support Account')

# Assign users to accounts
projectq.users << admin
projectq.users << qa
projectq.users << manager
projectq.users << danray
everpresent.users << admin

# # Set the desired number of Faker accounts to generate
# num_accounts_to_generate = 50
# 
# # Initialize an array to track used names
# used_names = []
# used_account_names = []
# 
# # Loop to generate and save users and accounts
# num_accounts_to_generate.times do
#   name = Faker::Name.name
#   account_name = Faker::Company.name
# 
#   # Ensure the generated name is unique
#   name = Faker::Name.name while used_names.include?(name)
# 
#   account_name = Faker::Company.name while used_account_names.include?(account_name)
# 
#   used_names << name
#   used_account_names << account_name
# 
#   # Create a new user with a unique name and random data
#   faker_user = User.create!(
#     name:,
#     email: Faker::Internet.email,
#     password: 'password',
#     password_confirmation: 'password',
#     confirmed_at: Time.now,
#     role: User.roles.keys.sample
#   )
# 
#   # Create a new account with random data
#   faker_account = Account.create!(
#     name: account_name,
#     description: Faker::Lorem.sentence,
#     site: Account.sites.keys.sample,
#     enable_kpi: Faker::Boolean.boolean
#   )
# 
#   # Assign the user to the account
#   faker_account.users << faker_user
# end
