require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:projectq)
  end

  test 'name should be present' do
    @account.name = ''
    assert_not @account.valid?
  end

  test 'name should be unique' do
    @account.name = 'projectq'
    assert @account.valid?
  end

  test 'name should be at least 50 characters' do
    @account.name = 'a' * 51
    assert_not @account.valid?
  end

end
