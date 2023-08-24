# == Schema Information
#
# Table name: notes
#
# id                          :bigint                 not null, primary key
# content                     :text
# notable_type                :string                 not null, foreign key
# notable_id                  :bigint                 not null, foreign key
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_notes_on_notable
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
