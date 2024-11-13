class RemoveTicketReferencetoComment < ActiveRecord::Migration[7.0]
  def change
    remove_reference :comments, :ticket, foreign_key: true
  end
end
