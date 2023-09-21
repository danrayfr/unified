class Schedule < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :participants, class_name: 'User', join_table: 'schedules_users'

  validates :title, presence: true
  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum :category, %i[coaching qa meeting]

  has_many :notifications, through: :user, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  after_create_commit :notify_recipient
  before_destroy :clean_notifications

  private

  def notify_recipient
    ScheduleNotification.with(schedule: self).deliver_later(participants)
  end

  def clean_notifications
    notifications_as_ticket.destroy_all
  end
end
