require 'test_helper'

class TicketDetailTest < ActiveSupport::TestCase
  def setup
    @ticket_details = ticket_details(:one)
  end

  test 'content should not be empty' do
    @ticket_details.content = ''
    assert_not @ticket_details.valid?
  end

  test 'access level should not be empty' do
    @ticket_details.access_level = ''
    assert_not @ticket_details.valid?
  end
end
