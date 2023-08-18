require 'test_helper'

# rubocop:disable Metrics/ClassLength
class AccountsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @agent = users(:agent)
    @admin = users(:admin)
    @account = accounts(:flexport)
    @manager = users(:manager1)
    @other_manager = users(:manager2)
  end

  test 'should get index' do
    sign_in @agent
    get accounts_url
    assert_response :success
  end

  test 'should get new' do
    sign_in @admin
    get new_account_url
    assert_response :success
  end

  test 'should create account' do
    sign_in @admin
    assert_difference('Account.count', 1) do
      post accounts_url,
           params: { account: { name: 'Everpresent', description: 'Game support account', slug: 'everpresent' } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test 'should show account' do
    sign_in @agent
    @account.users << @agent
    get account_url(@account)
    assert_response :success
  end

  test 'should not show account for non-member' do
    sign_in @agent
    get account_url(@account)
    assert_redirected_to accounts_url
    assert_equal "You're not a member of the account.", flash[:notice]
  end

  test 'should get edit' do
    sign_in @admin
    get edit_account_url(@account)
    assert_response :success
  end

  test 'should update account' do
    sign_in @admin
    assert_no_difference 'Account.count' do
      patch account_url(@account),
            params: { account: { name: 'Mythical Games', description: 'Customer service account',
                                 slug: 'mythical-games' } }
    end
    assert_redirected_to account_url(Account.first)
  end

  test 'should destroy account' do
    sign_in @admin
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end

  test 'join account' do
    sign_in @agent
    assert_difference('@account.users.count', 1) do
      post join_account_url(@account)
    end

    assert_redirected_to account_url(@account)
    assert_equal 'You have joined the account.', flash[:notice]
  end

  test 'leave account' do
    sign_in @agent

    @account.users << @agent

    assert_difference('@account.users.count', -1) do
      delete leave_account_url(@account)
    end

    assert_redirected_to accounts_url
    assert_equal 'You have left the account.', flash[:notice]
  end

  test 'invite user to account' do
    sign_in @manager

    assert_difference('@account.users.count', 1) do
      post invite_account_url(@account), params: { user: { email: @agent.email } }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'User has been invited to the account.', flash[:notice]
  end

  test 'invite existing manager to account' do
    sign_in @manager

    @account.users << @other_manager

    assert_no_difference('@account.users.count') do
      post invite_account_url(@account), params: { user: { email: @other_manager.email } }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'User is already a member in this account.', flash[:notice]
  end

  test 'invite existing agent to account' do
    sign_in @manager

    @account.users << @agent

    assert_no_difference('@account.users.count') do
      post invite_account_url(@account), params: { user: { email: @agent.email } }
    end

    assert_redirected_to accounts_url
    assert_equal "#{@agent.email} have reach your maximum account allowed.", flash[:notice]
  end

  test 'invite non-exisiting manager to account' do
    sign_in @manager

    assert_difference('@account.users.count', 1) do
      post invite_account_url(@account), params: { user: { email: @other_manager.email } }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'User has been invited to the account.', flash[:notice]
  end

  test 'invite non-exisiting agent to account' do
    sign_in @manager

    assert_difference('@account.users.count', 1) do
      post invite_account_url(@account), params: { user: { email: @agent.email } }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'User has been invited to the account.', flash[:notice]
  end

  test 'invite agent that already has account' do
    sign_in @manager

    @account.users << @agent

    assert_no_difference('@account.users.count') do
      post invite_account_url(@account), params: { user: { email: @agent.email } }
    end

    assert_redirected_to accounts_url
    assert_equal "#{@agent.email} have reach your maximum account allowed.", flash[:notice]
  end

  test 'remove user in the account' do
    sign_in @manager

    @account.users << @agent

    assert_difference '@account.users.count', -1 do
      delete remove_account_url(@account), params: { email: @agent.email }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'Successfully removed the user.', flash[:notice]
  end

  test 'remove user not in the account' do
    sign_in @manager

    @account.users << @agent

    assert_no_difference '@account.users.count' do
      delete remove_account_url(@account), params: { email: 'diego@user.com' }
    end

    assert_redirected_to account_url(@account)
    assert_equal 'User with the provided email not found.', flash[:alert]
  end
end
# rubocop:enable Metrics/ClassLength
