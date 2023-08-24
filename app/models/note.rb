class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  has_rich_text :content

  validates :content, presence: true
end
