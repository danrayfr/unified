class Schedule < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum :category, %i[coaching qa meeting]
end
