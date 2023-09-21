class Schedule < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :participants, class_name: 'User', join_table: 'schedules_users'

  validates :title, presence: true
  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum :category, %i[coaching qa meeting]
end
