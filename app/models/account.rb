# frozen_string_literal: true

class Account < ApplicationRecord
  validates :name, uniqueness: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
end

# validates name and description. name should be unique.
# name and description should minimum and maximum characters.
