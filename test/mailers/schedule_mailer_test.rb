require "test_helper"

class ScheduleMailerTest < ActionMailer::TestCase
  test "schedule_notification" do
    mail = ScheduleMailer.schedule_notification
    assert_equal "Schedule notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
