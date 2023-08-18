# frozen_string_literal: true

class Account < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged history finders]

  before_validation :generate_uuid, on: :create
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }

  has_and_belongs_to_many :users

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  private

  # Generate a random number for uuid, since I don't want the field uuid to be empty.
  def generate_uuid
    self.uid ||= SecureRandom.uuid
  end
end

# validates name and description. name should be unique.
# name and description should minimum and maximum characters.
