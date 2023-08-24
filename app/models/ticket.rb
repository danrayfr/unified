class Ticket < ApplicationRecord
  Pagy::DEFAULT[:items] = 6
  belongs_to :user
  belongs_to :account
  has_many :ticket_details, dependent: :destroy
  accepts_nested_attributes_for :ticket_details, allow_destroy: true, reject_if: :all_blank

  validates :link, presence: true
  validates :modified_by, presence: true
end
