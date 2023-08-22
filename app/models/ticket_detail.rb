class TicketDetail < ApplicationRecord
  belongs_to :ticket, optional: true
  enum access_level: %i[outbound inbound internal client]

  validates :content, presence: true
  validates :access_level, presence: true
end
