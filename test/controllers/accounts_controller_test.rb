require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @agent = users(:agent)
    @admin = users(:admin)
    @account = accounts(:flexport)
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
    get account_url(@account)
    assert_response :success
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
end
