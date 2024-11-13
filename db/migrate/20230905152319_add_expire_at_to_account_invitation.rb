class AddExpireAtToAccountInvitation < ActiveRecord::Migration[7.0]
  def change
    add_column :account_invitations, :expires_at, :datetime
  end
end
