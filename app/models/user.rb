# == Schema Information
#
# Table name: users
#
# id                          :bigint                 not null, primary key
# uid                         :string                 not null, unique key
# provider                    :string
# email                       :string
# title                       :string
# role                        :integer                default(0)
# account_limit               :integer                default(1)
# encrypted_password          :string                 not null, default('')
# reset_password_token        :string
# reset_password_sent_at      :datetime
# remember_created_at         :datetime
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_users_on_email
# index_users_on_reset_password_token
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  before_validation :generate_uuid, on: :create
  before_validation :default_provider, on: :create

  validates :email, presence: true, uniqueness: true
  # validate :allowed_email_domain, on: :create
  validate :validate_account_limit, on: :update

  enum role: %i[agent qa manager operations admin]

  has_many :tickets, dependent: :destroy
  has_many :coachings, dependent: :destroy
  has_and_belongs_to_many :accounts
  has_many :comments, dependent: :destroy
  has_many :invitees, class_name: 'User', foreign_key: :invited_by_id

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image

      # If you are using confirmable and the provider(s) you use to validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  # Responsible for validating user account limit per role.
  def validate_account_limit
    return if operations? || admin?

    account_limit == accounts.size
  end

  def validate_coaching_access
    manager? || agent? || admin? ? true : false
  end

  def validate_ticket_access
    manager? || qa? ? true : false
  end

  def manager?
    role == 'manager'
  end

  def qa?
    role == 'qa'
  end

  def agent?
    role == 'agent'
  end

  def operations?
    role == 'operations'
  end

  def admin?
    role == 'admin'
  end

  def allowed_email_domain
    return if email.match(/\A[^@]+@supportninja\.com\z/i)

    errors.add(:email, 'must have an allowed email domain')
  end

  private

  # Generate a random number for uuid, since we don't want the attribute uuid to be empty,
  # and attribute can also be use to identify user.
  def generate_uuid
    self.uid ||= SecureRandom.uuid
  end

  # Add a default value to a user if provider is empty, null: false
  def default_provider
    self.provider = 'default' if provider.nil?
  end
end
