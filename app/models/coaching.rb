# == Schema Information
#
# Table name: coachings
#
# id                          :bigint                 not null, primary key
# coaching_start_date         :date
# coaching_end_date           :date
# acknowledgement             :boolean                default(false)
# date_acknowledged           :datetime
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_coachings_on_account_id                       (account_id)
# index_coachings_on_user_id                          (user_id)
#
# Foreign keys
#
# fk_rails ... (account_id => accounts.id)
# fk_rails ... (user_id => users.id)
#

class Coaching < ApplicationRecord
  default_scope -> { order(acknowledgement: :asc, created_at: :desc) }
  Pagy::DEFAULT[:items] = 6
  
  belongs_to :user
  belongs_to :account
  has_one :note, as: :notable, dependent: :destroy
  accepts_nested_attributes_for :note

  validates :coaching_start_date, presence: true
  validates :coaching_end_date, presence: true
  validates :user, presence: { message: 'Agent should not be blank.' }
  validate :validate_week_duration

  has_many :notifications, through: :user, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'

  has_many :comments, as: :commentable, dependent: :destroy

  after_create_commit :notify_recipient
  before_destroy :clean_notifications

  # rubocop:disable Metrics/AbcSize
  def validate_week_duration
    return unless coaching_start_date.present? && coaching_end_date.present?

    # Get the week number and year for both dates
    start_week_number = coaching_start_date.strftime('%U').to_i
    start_year = coaching_start_date.year
    end_week_number = coaching_end_date.strftime('%U').to_i
    end_year = coaching_end_date.year

    # Compare week numbers and years
    return if start_week_number == end_week_number && start_year == end_year

    errors.add(:coaching_end_date,
               'must be in the same week as the start date')
  end
  # rubocop:enable Metrics/AbcSize

  def acknowledged?
    return 'No Date' unless acknowledgement

    # Calculate the week and year for the start date
    start_week = coaching_start_date.strftime('%U').to_i

    coaching_start_date.strftime('%B %d, %Y')
    coaching_end_date.strftime('%B %d, %Y')

    "Week #{start_week}" # (#{formatted_start_date} - #{formatted_end_date})
  end

  def week
    # Calculate the week and year for the start date
    start_week = coaching_start_date.strftime('%U').to_i
    "Week##{start_week}"
  end

  def date_format
    formatted_start_date = coaching_start_date.strftime('%B %d, %Y')
    formatted_end_date = coaching_end_date.strftime('%B %d, %Y')

    "(#{formatted_start_date} - #{formatted_end_date})"
  end

  private

  def notify_recipient
    CoachingNotification.with(coaching: self).deliver_later(user)
  end

  def clean_notifications
    notifications_as_ticket.destroy_all
  end
end
