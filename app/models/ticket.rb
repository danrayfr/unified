class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :ticket_details, dependent: :destroy
  accepts_nested_attributes_for :ticket_details, allow_destroy: true, reject_if: :all_blank

  validates :link, presence: true
  validates :assignee, presence: true

  def validate_user
    user.manager? || user.qa? ? true : false
  end

  def check_membership
    account.users.include?(user)
  end
end
