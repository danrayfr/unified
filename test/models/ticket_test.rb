require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  def setup
    @ticket = @manager.tickets.build(link: 'https://supportninja.zendesk.com', assignee: @agent.name,
                                     account: @account)
    @manager = users(:manager1)
    @agent = users(:agent)
    @qa = users(:qa)
    @account = accounts(:projectq)
  end

  test 'should be valid' do
    assert @ticket.valid?
  end

  test 'link should not be empty' do
    @ticket.link = ''
    assert_not @ticket.valid?
  end

  test 'assignee should not be empty' do
    @ticket.assignee = ''
    assert_not @ticket.valid?
  end

  test 'manager and qa can only create a ticket entry' do
    @ticket.user = @manager
    assert @ticket.validate_user

    @ticket.user = @qa
    assert @ticket.validate_user

    @ticket.user = @agent
    assert_not @ticket.validate_user
  end
end
