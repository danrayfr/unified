class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  has_one :note, as: :notable
  accepts_nested_attributes_for :note
end
