class CoachingTemplate < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :account

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  has_one :note, as: :notable
  accepts_nested_attributes_for :note
end
