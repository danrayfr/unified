# == Schema Information
#
# Table name: notes
#
# id                          :bigint                 not null, primary key
# content                     :text
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_notes_on_notable                              (notable_id, notable_type)
#
# Foreign keys
#
# fk_rails ... (notable_type => model) e.g. ['notable_type', 'Coaching']
# fk_rails ... (notable_id => models.id)
#

class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  has_rich_text :content

  validates :content, presence: true
end
