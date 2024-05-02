# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# uid                         :string                 not null, unique key
# name                        :string
# slug                        :string
# site                        :integer
# status                      :integer                default(0)
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_accounts_users_on_account_id_and_user_id      (account_id_and_user_id)
# index_accounts_users_on_user_id_and_account_id      (index_accounts_users_on_user_id_and_account_id)
#
# Foreign keys
#
# fk_rails ... (user_id => users.id)
# fk_rails ... (account_id => accounts.id)
#

class Account < ApplicationRecord
  extend FriendlyId
  Pagy::DEFAULT[:items] = 8

  friendly_id :uid, use: %i[slugged history finders]

  default_scope -> { order(created_at: :asc) }

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :site, presence: true
  after_validation :generated_uid, on: :create
  after_create :create_default_qa_template

  enum :site, %i[sanctum hideout foundry remote]
  enum :status, %i[active inactive pending]

  has_and_belongs_to_many :users
  has_many :account_invitations, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :coachings, dependent: :destroy
  has_many :qualities, dependent: :destroy
  has_many :qa_templates, dependent: :destroy
  has_many :coaching_templates, dependent: :destroy

  def should_generate_new_friendly_id?
    slug.blank? || uid_changed?
  end

  def agent_count
    users.agent.count
  end

  def member?(user)
    users.include?(user)
  end

  def owner?(current_user)
    user_uid == current_user.uid
  end

  def invite_user(email)
    user = User.find_by(email:)

    if user
      return 'User is already a member in this account.' if self.users.include?(user)
      return 'User has a pending invitation' if account_invitations.exists?(user_id: user.id, accepted: false)
    else
      return 'User with the provided email not found.' unless user
    end

    email_invitation(user, generate_invitation_token)
  end

  def self.accept_invitation(token)
    invitation = AccountInvitation.find_by(token:)

    return { success: false, message: 'Invalid invitation link.' } unless invitation
    return { success: false, message: 'User already a member' } if user_already_member?(invitation)
    return { success: false, message: 'Invitation already expired, please create a new one.' } if invitation_expired?(invitation)

    accept_and_process_invitation(invitation)
  end

  private

  # Generate a random number for uuid, since I don't want the field uuid to be empty.
  def generated_uid
    self.uid ||= loop do
      hex = generate_hex
      break hex unless Account.exists?(uid: hex)
    end
  end

  def generate_hex
    SecureRandom.hex(4).to_i(16) % 10_000_000
  end

  def generate_invitation_token
    SecureRandom.urlsafe_base64(32)
  end

  def email_invitation(user, token)
    invitation = account_invitations.new(user:, accepted: false, token:, expires_at: 36.hours.from_now)

    if invitation.save
      AccountInvitationMailer.invite(invitation).deliver_now!

      'User has been invited to the account.'
    else
      'Failed to create an invitation.'
    end
  end

  def self.user_already_member?(invitation)
    invitation.account.users.include?(invitation.user)
  end

  def self.invitation_expired?(invitation)
    invitation.expires_at < Time.now
  end

  def self.accept_and_process_invitation(invitation)
    invitation.update(accepted: true, accepted_at: Time.now)
    invitation.account.users << invitation.user
    { success: true, message: 'Invitation accepted, user added to the account.', account: invitation.account }
  end

  def create_default_qa_template
    return unless qa_templates.empty?
    default_qa_template_data = {
      name: 'Default template',
      published: true,
      metrics: [
        { 'content' => '', 'deduction' => '10', 'metric_name' => 'Grammar' },
        { 'content' => '', 'deduction' => '3', 'metric_name' => 'Punctuation' },
        { 'content' => '', 'deduction' => '8', 'metric_name' => 'Accuracy' }
      ]
    }
    qa_templates.create(default_qa_template_data)
  end
end
