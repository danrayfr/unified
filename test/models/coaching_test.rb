require 'test_helper'

class CoachingTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:projectq)
    @agent = users(:agent)
    @coaching = @account.coachings.build(coaching_start_date: DateTime.parse('2023-08-21'),
                                         coaching_end_date: DateTime.parse('2023-08-26'), user_id: @agent.id,
                                         date_acknowledged: nil, acknowledgement: false)
    @note = @coaching.build_note(content: 'hello world')
  end

  test 'coaching should be valid' do
    assert @coaching.valid?
  end

  test 'note should be valid' do
    assert @note.valid?
  end

  test 'coaching start date should be present' do
    @coaching.coaching_start_date = ''
    assert_not @coaching.valid?
  end

  test 'coaching end date should be present' do
    @coaching.coaching_end_date = ''
    assert_not @coaching.valid?
  end

  test 'coaching user should be present' do
    @coaching.user_id = ''
    assert_not @coaching.valid?
  end

  test 'coaching account should be present' do
    @coaching.account_id = ''
    assert_not @coaching.valid?
  end

  test 'coaching end date must be in the same week as start date' do
    @coaching.coaching_end_date = DateTime.parse('2023-08-27')

    assert_not @coaching.valid?
    assert_equal ['must be in the same week as the start date'], @coaching.errors[:coaching_end_date]
  end

  test 'coaching end date can be in the same week as start date' do
    assert @coaching.valid?
  end

  test 'acknowledged? returns correct string when acknowledged' do
    coaching = Coaching.new(
      coaching_start_date: Date.new(2023, 8, 21),
      coaching_end_date: Date.new(2023, 8, 26),
      acknowledgement: true
    )

    expected_result = 'Week#34 (August 21, 2023 - August 26, 2023)'
    assert_equal expected_result, coaching.acknowledged?
  end

  test 'acknowledged? returns "No Date" when not acknowledged' do
    coaching = Coaching.new(
      coaching_start_date: Date.new(2023, 8, 21),
      coaching_end_date: Date.new(2023, 8, 26),
      acknowledgement: false
    )

    assert_equal 'No Date', coaching.acknowledged?
  end
end
