class Comment < ApplicationRecord
  default_scope -> { order(pinned: :desc, created_at: :desc) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_one :note, as: :notable
  accepts_nested_attributes_for :note
end
