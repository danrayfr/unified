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
  default_scope -> { order(acknowledgement: :asc, created_at: :desc) }
  belongs_to :user
  belongs_to :account

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  has_many :comments, as: :commentable, dependent: :destroy

  validates :link, presence: true
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user, dependent: :destroy

  after_create_commit :notify_recipient
  before_destroy :clean_notifications

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
end
