# == Schema Information
#
# Table name: account_invitations
#
# id                          :bigint                 not null, primary key
# accepted                    :boolean                not null, unique key
# accepted_at                 :Time.now
# token                       :string
# expires_at                  :string
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_account_invitations_on_account_id      (account_id)
# index_account_invitations_on_token           (token)
# index_account_invitations_on_user_id         (user_id)
#

class AccountInvitation < ApplicationRecord
  belongs_to :account
  belongs_to :user
end
