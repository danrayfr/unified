# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# link                        :string
# modified_by                 :string
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_tickets_on_account_id                         (account_id)
# index_tickets_on_user_id                            (user_id)
#
# Foreign keys
#
# fk_rails ... (user_id => users.id)
# fk_rails ... (account_id => accounts.id)
#

class Ticket < ApplicationRecord
  Pagy::DEFAULT[:items] = 6

  belongs_to :user
  belongs_to :account
  has_many :ticket_details, dependent: :destroy
  has_one :quality, dependent: :destroy

  accepts_nested_attributes_for :ticket_details, allow_destroy: true, reject_if: :all_blank

  validates :link, presence: true
  validates :modified_by, presence: true
end
