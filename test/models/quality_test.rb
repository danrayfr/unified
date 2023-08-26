# == Schema Information
#
# Table name: accounts
#
# id                          :bigint                 not null, primary key
# rating                      :integer
# acknowledgement             string
# date_acknowledged           :boolean               default(false)
# created_at                  :datetime               not null
# updated_at                  :datetime               not null
#
# Indexes
#
# index_qualities_on_ticket_id                         (index_qualities_on_ticket_id)
#
# Foreign keys
#
# fk_rails ... (ticket_id => tickets.id)
#

require 'test_helper'

class QualityTest < ActiveSupport::TestCase
  def setup
    @ticket = tickets(:one)
    @qa = @ticket.build_quality(rating: 99)
  end

  test 'should be valid' do
    assert @qa.valid?
  end

  test 'rating should be present' do
    @qa.rating = ''
    assert_not @qa.valid?
  end

  test 'rating should be a number only' do
    @qa.rating = 'LETTER'
    assert_not @qa.valid?
  end

  test 'value should be greather than or equal to 0' do
    @qa.rating = -1
    assert_not @qa.valid?

    @qa.rating = 0
    assert @qa.valid?
  end

  test 'value should be less than or equal to 100' do
    @qa.rating = 101
    assert_not @qa.valid?

    @qa.rating = 100
    assert @qa.valid?
  end
end
