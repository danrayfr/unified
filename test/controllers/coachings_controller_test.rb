# QA isn't included in the coachings test since they,
# are not able to access the coaching resources.

require 'test_helper'

class CoachingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @account = accounts(:projectq)
    @coaching = coachings(:one)
    @agent = users(:agent)
    @manager = users(:manager1)
    @admin = users(:admin)
  end

  def check_membership(user)
    @account.users << user
    @account.users.include?(user)
  end
end

class IndexTesting < CoachingsControllerTest
  test 'agent should get index' do
    sign_in @agent
    check_membership(@agent)

    get account_coachings_url(@account)
    assert_response :success
  end

  test 'manager should get index' do
    sign_in @manager
    check_membership(@manager)

    get account_coachings_url(@account)
    assert_response :success
  end

  test 'admin should get index' do
    sign_in @admin
    check_membership(@admin)

    get account_coachings_url(@account)
    assert_response :success
  end
end

class ShowTesting < CoachingsControllerTest
  test 'agent should get show' do
    sign_in @agent
    check_membership(@agent)

    get account_coachings_url(@account)
    assert_response :success
  end

  test 'manager should get show' do
    sign_in @manager
    check_membership(@manager)

    get account_coachings_url(@account)
    assert_response :success
  end

  test 'admin should get show' do
    sign_in @admin
    check_membership(@admin)

    get account_coachings_url(@account)
    assert_response :success
  end
end

class NewTesting < CoachingsControllerTest
  test 'agent should get new' do
    sign_in @agent
    check_membership(@agent)

    get new_account_coaching_url(@account)
    assert_redirected_to account_coachings_url
    assert_equal "You're not allowed create or edit a coaching form.", flash[:alert]
  end

  test 'manager should get new' do
    sign_in @manager
    check_membership(@manager)

    get new_account_coaching_url(@account)
    assert_response :success
  end

  test 'admin should get new' do
    sign_in @admin

    # Check membership
    @account.users << @admin
    @account.users.include?(@admin)

    get new_account_coaching_url(@account)
    assert_redirected_to account_coachings_url
    assert_equal "You're not allowed create or edit a coaching form.", flash[:alert]
  end
end

class CreateTesting < CoachingsControllerTest
  test 'manager should be able to create a coaching entry' do
    sign_in @manager
    check_membership(@manager)

    assert_difference('Coaching.count', 1) do
      post account_coachings_url(@account),
           params: { coaching: { coaching_start_date: DateTime.parse('2023-08-21'),
                                 coaching_end_date: DateTime.parse('2023-08-26'), user_id: @agent.id,
                                 account_id: @account.id, date_acknowledged: nil, acknowledgement: false } }
    end

    coaching = Coaching.last

    assert_redirected_to account_coaching_url(@account, coaching)
  end
end

class EditTesting < CoachingsControllerTest
  test 'agent should get edit' do
    sign_in @agent
    check_membership(@agent)

    get new_account_coaching_url(@account)
    assert_redirected_to account_coachings_url
    assert_equal "You're not allowed create or edit a coaching form.", flash[:alert]
  end

  test 'manager should get edit' do
    sign_in @manager
    check_membership(@manager)

    get new_account_coaching_url(@account)
    assert_response :success
  end

  test 'admin should get edit' do
    sign_in @admin

    # Check membership
    @account.users << @admin
    @account.users.include?(@admin)

    get new_account_coaching_url(@account)
    assert_redirected_to account_coachings_url
    assert_equal "You're not allowed create or edit a coaching form.", flash[:alert]
  end
end

class UpdateTesting < CoachingsControllerTest
  test 'manager should be able to update a coaching entry' do
    sign_in @manager
    check_membership(@manager)

    assert_no_difference('Coaching.count') do
      patch account_coaching_url(@account, @coaching),
            params: { coaching: { coaching_start_date: DateTime.parse('2023-08-21'),
                                  coaching_end_date: DateTime.parse('2023-08-26'), user_id: @agent.id,
                                  account_id: @account.id, date_acknowledged: nil, acknowledgement: false } }
    end

    coaching = Coaching.last

    assert_redirected_to account_coaching_url(@account, coaching)
  end
end

class AcknowledgementTesting < CoachingsControllerTest
  test 'agent should be able to get acknowledgement' do
    sign_in @agent
    check_membership(@agent)

    get acknowledgement_account_coaching_url(@account, @coaching)
    assert_response :success
    # assert_equal "You're not allowed create or edit a coaching form.", flash[:alert]
  end

  test 'manager should not be able to get acknowledgement' do
    sign_in @manager
    check_membership(@manager)

    get acknowledgement_account_coaching_url(@account, @coaching)
    assert_redirected_to account_coachings_url(@account)
    assert_equal "You're not allowed to acknowledge this coaching record.", flash[:alert]
  end

  test 'agent should be able to acknowledge a coaching record' do
    sign_in @agent
    check_membership(@agent)

    assert_no_difference('Coaching.count') do
      patch account_coaching_url(@account, @coaching),
            params: { coaching: { coaching_start_date: DateTime.parse('2023-08-21'),
                                  coaching_end_date: DateTime.parse('2023-08-26'), user_id: @agent.id,
                                  account_id: @account.id, date_acknowledged: Time.now, acknowledgement: true } }
    end

    coaching = Coaching.last

    assert_redirected_to account_coaching_url(@account, coaching)
  end
end

class DestroyTesting < CoachingsControllerTest
  test 'admin should get to destroy a coaching record' do
    sign_in @admin
    check_membership(@admin)

    get account_coaching_url(@account, @coaching)

    assert_difference('Coaching.count', -1) do
      delete account_coaching_url(@account, @coaching)
    end

    assert_redirected_to account_coachings_url
  end

  test 'agent is not allowed to destroy a coaching record' do
    sign_in @agent
    check_membership(@agent)

    get account_coaching_url(@account, @coaching)

    assert_no_difference('Coaching.count') do
      delete account_coaching_url(@account, @coaching)
    end

    assert_redirected_to root_url
    assert_equal "You're not authorized.", flash[:alert]
  end

  test 'manager is not allowed to destroy a coaching record' do
    sign_in @manager
    check_membership(@manager)

    get account_coaching_url(@account, @coaching)

    assert_no_difference('Coaching.count') do
      delete account_coaching_url(@account, @coaching)
    end

    assert_redirected_to root_url
    assert_equal "You're not authorized.", flash[:alert]
  end
end
