class ChangeReferencesFromTicketToAccount < ActiveRecord::Migration[7.0]
  def up
    # Remove the reference to "tickets" (assuming it was the old reference)
    remove_reference :qualities, :ticket, index: true, foreign_key: true

    # Add references to "accounts" and "users" (assuming these are the new references)
    add_reference :qualities, :account, index: true, foreign_key: true
    add_reference :qualities, :user, index: true, foreign_key: true
  end

  def down
    # This is the reverse migration, in case you need to roll back.
    # Add the reference back to "tickets" and remove references to "accounts" and "users".
    add_reference :qualities, :ticket, index: true, foreign_key: true
    remove_reference :qualities, :account, index: true, foreign_key: true
    remove_reference :qualities, :user, index: true, foreign_key: true
  end
end
