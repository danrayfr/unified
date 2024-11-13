# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# rating                      :integer
# acknowledgement             string
# date_acknowledged           :boolean               default(false)
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_qualities_on_ticket_id                         (index_qualities_on_ticket_id)
#
# Foreign keys
#
# fk_rails ... (ticket_id => tickets.id)
#

class Quality < ApplicationRecord
  extend FriendlyId
  Pagy::DEFAULT[:items] = 6
  friendly_id :uid, use: %i[slugged history finders]

  default_scope -> { order(acknowledgement: :asc, created_at: :desc) }
  belongs_to :user
  belongs_to :account

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  has_many :comments, as: :commentable, dependent: :destroy

validates :link, presence: true
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  after_validation :generated_uid, on: :create

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, as: :recipient, dependent: :destroy

  after_create_commit :notify_recipient
  before_destroy :clean_notifications

  def should_generate_new_friendly_id?
     slug.blank? || uid_changed?
  end

  def notify_recipient
    QualityNotification.with(quality: self).deliver_later(user)
  end

  def clean_notifications
    notifications_as_quality.destroy_all
  end

  def self.filter_by_agent_email(agent)
    return all if agent == 'all' || agent.blank?

    user = User.find_by(email: agent)
    where(user:)
  end

  def generated_uid
    self.uid ||= loop do
      hex = generate_hex
      break hex unless Quality.exists?(uid: hex)
    end
  end

  def generate_hex
    SecureRandom.hex(4).to_i(16) % 10_000_000
  end
end
