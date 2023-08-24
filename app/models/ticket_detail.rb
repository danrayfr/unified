# == Schema Information
#
# Table name: ticket_details
#
# id                          :bigint                 not null, primary key
# content                     :string
# access_level                :integer                not null, foreign key
# ticket_id                   :bigint                 not null, foreign key
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_ticket_details_on_ticket_id
#
# Foreign Key
#
# fk_rails ... (ticket_id => tickets.id)
#

class TicketDetail < ApplicationRecord
  belongs_to :ticket, optional: true
  enum access_level: %i[outbound inbound internal client]

  has_rich_text :content
  validates :content, presence: true
  validates :access_level, presence: true
end
