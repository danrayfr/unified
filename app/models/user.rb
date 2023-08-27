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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  before_validation :generate_uuid, on: :create
  before_validation :default_provider, on: :create

  validate :validate_account_limit_per_role, on: :update

  enum role: %i[agent manager qa admin]

  has_many :tickets
  has_many :coachings
  has_and_belongs_to_many :accounts
  has_many :comments, dependent: :destroy

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

  # Responsible for validating user account limit per role,
  # agent = 1, manager = 2, QA = 3 or more.
  def validate_account_limit_per_role
    if agent? && accounts.size >= 1
      false
    elsif manager? && accounts.size >= 2
      false
    elsif qa? && accounts.size >= 3
      false
    else
      true
    end
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

  private

  # Generate a random number for uuid, since I don't want the field uuid to be empty.
  def generate_uuid
    self.uid ||= SecureRandom.uuid
  end

  # Add a default value to a user if provider is empty, null: false
  def default_provider
    self.provider = 'default' if provider.nil?
  end
end
