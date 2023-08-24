require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  def setup
    @manager = users(:manager1)
    @agent = users(:agent)
    @qa = users(:qa)
    @account = accounts(:projectq)
    @ticket = @manager.tickets.build(link: 'https://supportninja.zendesk.com', modified_by: @agent.name,
                                     account: @account)
  end

  test 'should be valid' do
    assert @ticket.valid?
  end

  test 'link should not be empty' do
    @ticket.link = ''
    assert_not @ticket.valid?
  end

  test 'assignee should not be empty' do
    @ticket.modified_by = ''
    assert_not @ticket.valid?
  end

  test 'manager and qa can only create a ticket entry' do
    @ticket.user = @manager
    assert @manager.validate_ticket_access

    @ticket.user = @qa
    assert @qa.validate_ticket_access

    @ticket.user = @agent
    assert_not @agent.validate_ticket_access
  end
end
