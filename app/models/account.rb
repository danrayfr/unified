# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# uid                         :string                 not null, unique key
# name                        :string
# description                 :string
# slug                        :string
# site                        :integer
# enable_kpi                  :boolean                default(true)
# status                      :integer                default(0)
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_accounts_users_on_account_id_and_user_id      (account_id_and_user_id)
# index_accounts_users_on_user_id_and_account_id      (index_accounts_users_on_user_id_and_account_id)
#
# Foreign keys
#
# fk_rails ... (user_id => users.id)
# fk_rails ... (account_id => accounts.id)
#

class Account < ApplicationRecord
  extend FriendlyId
  Pagy::DEFAULT[:items] = 8
  friendly_id :name, use: %i[slugged history finders]

  before_validation :generate_uuid, on: :create
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }

  enum :site, %i[hideout sanctum foundry remote]
  enum :status, %i[active inactive pending]

  has_and_belongs_to_many :users
  has_many :tickets
  has_many :coachings

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  private

  # Generate a random number for uuid, since I don't want the field uuid to be empty.
  def generate_uuid
    self.uid ||= SecureRandom.uuid
  end
end
