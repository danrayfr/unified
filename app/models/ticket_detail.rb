class TicketDetail < ApplicationRecord
  belongs_to :ticket, optional: true
  enum access_level: %i[outbound inbound internal client]

  has_rich_text :content
  validates :content, presence: true
  validates :access_level, presence: true
end
