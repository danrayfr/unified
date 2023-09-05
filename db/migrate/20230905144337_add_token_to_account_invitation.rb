class AddTokenToAccountInvitation < ActiveRecord::Migration[7.0]
  def change
    add_column :account_invitations, :token, :string
    add_index :account_invitations, :token, unique: true
  end
end
