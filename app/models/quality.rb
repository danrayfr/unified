# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# rating                      :integer
# acknowledgement             string
# date_acknowledged           :boolean               default(false)
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_qualities_on_ticket_id                         (index_qualities_on_ticket_id)
#
# Foreign keys
#
# fk_rails ... (ticket_id => tickets.id)
#

class Quality < ApplicationRecord
  belongs_to :ticket
  has_one :note, as: :notable

  accepts_nested_attributes_for :note

  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
