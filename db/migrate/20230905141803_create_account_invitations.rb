class CreateAccountInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :account_invitations do |t|
      t.boolean :accepted
      t.datetime :accepted_at
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
