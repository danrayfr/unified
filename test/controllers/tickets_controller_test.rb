require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @account = accounts(:projectq)
    @user = users(:agent)
  end

  test 'should get index' do
    sign_in @user

    @account.users << @user

    get account_tickets_url(@account)
    assert_response :success
  end
end
