# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# link                        :string
# user_id                     :bigint                 not null, foreign key
# account_id                  :bigint                 not null, foreign key
# modified_by                 :string
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_tickets_on_account_id
# index_tickets_on_user_id
#
# Foreign keys
#
# fk_rails ... (user_id => users.id)
# fk_rails ... (account_id => accounts.id)
#

create_table "tickets", force: :cascade do |t|
  t.string "link"
  t.bigint "user_id", null: false
  t.bigint "account_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "modified_by"
  t.index ["account_id"], name: "index_tickets_on_account_id"
  t.index ["user_id"], name: "index_tickets_on_user_id"
end
class Ticket < ApplicationRecord
  Pagy::DEFAULT[:items] = 6
  belongs_to :user
  belongs_to :account
  has_many :ticket_details, dependent: :destroy
  accepts_nested_attributes_for :ticket_details, allow_destroy: true, reject_if: :all_blank

  validates :link, presence: true
  validates :modified_by, presence: true
end
