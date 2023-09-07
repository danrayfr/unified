# == Schema Information
#
# Table name: qa_templates
#
# id                          :bigint                 not null, primary key
# name                        :string
# published                   :boolean
# metrics                     :jsonb                  default: [], array: true
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_qa_templates_on_account_id                    (account_id)
#
# Foreign keys
#

class QaTemplate < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :account

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  validates :name, presence: true, uniqueness: true
end
